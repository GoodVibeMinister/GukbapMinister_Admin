//
//  AuthView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/07.
//

import SwiftUI

struct AuthView: View {
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var authManager: AuthManager
    
    
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack {
                Button {
                    appleLogin()
                } label: {
                    Text("애플로 로그인")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(alignment:.leading) {
                            Image("AppleLogin")
                                .frame(width: 50, alignment: .center)
                        }
                }
                .background(.black)
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .padding(.bottom, 30)
            }
        }
    }
    
    
    func appleLogin() {
        if let window {
            authManager.window = window
        }
        authManager.startAppleLogin()
    }
}
