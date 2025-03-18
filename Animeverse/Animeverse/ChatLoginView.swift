//
//  LoginView.swift
//  Kommunicate SwiftUI Sample app
//
//  Created by Mukesh on 18/09/20.
//

import SwiftUI
import Kommunicate

struct ChatLoginView: View {
    @Binding var isPresented: Bool

    @State private var userId: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField(
                    "User id (Use a random id for the first time)",
                    text: $userId
                )
                .autocapitalization(.none)
                .padding(10)
                .border(Color.gray, width: 1)

                SecureField("Password", text: $password)
                    .padding(10)
                    .border(Color.gray, width: 1)
                    .padding(.vertical)
                Button("Submit") {
                    self.login()
                }
                .frame(minWidth: nil, maxWidth: .infinity, minHeight: 40)
                .accentColor(.white)
                .background(Color.blue)
            }
            .padding()
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarTitle("Sign in", displayMode: .inline)
        }

    }

    func login() {
        let kmUser = KMUser()
        kmUser.userId = userId
        kmUser.password = password
//        let appId = (UIApplication.shared.delegate as! AppDelegate).appId
        Kommunicate.setup(applicationId: "11be8bc3aa73bea6f9cc1281935cebad3")
        Kommunicate.registerUser(kmUser) { response, error in
            guard error == nil else {
                print("[REGISTRATION] Kommunicate user registration error: %@", error.debugDescription)
                return
            }
            self.isPresented = false
            print("User registration was successful: %@ \(String(describing: response?.isRegisteredSuccessfully()))")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLoginView(isPresented: .constant(false))
    }
}
