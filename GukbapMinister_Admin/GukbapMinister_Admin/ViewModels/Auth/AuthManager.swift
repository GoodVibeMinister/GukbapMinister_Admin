//
//  AuthManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/07.
//

import Foundation
import UIKit
import CryptoKit
import SwiftUI
import AuthenticationServices

import Firebase
import FirebaseAuth
import FirebaseFirestore



enum LoginState {
    case appleLogin
    case logout
}

// MARK: -
class AuthManager: NSObject, ObservableObject {
    
    // MARK: - 프로퍼티
    let database = Firestore.firestore() // FireStore 참조 객체
    let currentUser = Auth.auth().currentUser
    
    var currentNonce: String? = nil
    var window: UIWindow? = nil
    
    // MARK: - @Published 변수
    @Published var loginState: LoginState = .logout // 로그인 상태 변수
    @Published var userInfo: User = User(userNickname: "", userEmail: "", userGrade: "", reviewCount: 0, storeReportCount: 0, favoriteStoreId: [])
    
    // MARK: - 자동로그인을 위한 UserDefaults 변수
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("loginPlatform") var loginPlatform: String = (UserDefaults.standard.string(forKey: "loginPlatform") ?? "")
    
    
    override init() {
        super.init()
        if self.isLoggedIn && currentUser != nil {
            self.fetchUserInfo(uid: self.currentUser?.uid ?? "")
        }
        
    }
    
    
    
    // MARK: 사용자 정보 가져오기
    func fetchUserInfo(uid: String) {
        let docRef = database.collection("User").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let data = try? document.data(as: User.self) {
                    self.userInfo = data
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - FireStore에 유저 정보 추가하는 함수
    func insertUserInFireStore(uid: String, userEmail: String, userName: String) {
        Task{
            do{
                try await database.collection("User").document(uid).setData([
                    "userEmail" : userEmail,
                    "userNickname" : userName,
                    "reviewCount" : 0,
                    "storeReportCount" : 0,
                    "favoriteStoreId" : [],
                    "userGrade" : "깍두기"
                ])
            }catch let error {
                print("\(#function) 파이어베이스 에러 : \(error)")
            }
        }//Task
    }

    
    // MARK: - 로그아웃
    // 로그인 상태 열거형 변수를 참조하여 해당하는 플랫폼 로그아웃 로직 실행
    func logout() {
        
        print("현재 로그인 플랫폼 - \(String(describing: self.loginState))")
        
        switch loginPlatform {
    
        case "appleLogin": // 애플로그인일때
            do {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.set("noLoginPlatform", forKey: "loginPlatform")
                try Auth.auth().signOut()
                self.loginState = .logout
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
        default: return
        }
    }
}

extension AuthManager {
    func startAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension AuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        print("여기 호출됩니다!")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            //Firebase 작업
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    print(#function, error.localizedDescription)
                    return
                }
                
                var fullName: String?
                if let familyName = appleIDCredential.fullName?.familyName, let givenName = appleIDCredential.fullName?.givenName{
                    fullName = familyName + givenName
                }
                
                guard let user = authResult?.user else { return }
                
                
                // 로그인 성공시 유저정보 FireStore에 저장
                self.insertUserInFireStore(uid: user.uid, userEmail: user.providerData.first?.email ?? "", userName: fullName ?? "임시닉네임")
                self.fetchUserInfo(uid: user.uid)
                self.loginState = .appleLogin
                
                // UserDefaults에 키-값 쌍 저장
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set("appleLogin", forKey: "loginPlatform")
            }
        }
    }
}

extension AuthManager:
    ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        window!
    }
}
