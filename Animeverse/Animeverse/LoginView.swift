import SwiftUI

struct LoginView: View {
    @State private var email: String = "test@gmail.com"
    @State private var password: String = "12345"
    @State private var isLoading = false
    @State private var loginSuccess = false
    @State private var errorMessage: String?

    private let primaryColor = Color(hex: "EC5408")

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(primaryColor)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // Title
                    Text("ANIMEVERSE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    // Input Fields
                    VStack(spacing: 25) {
                        LoginTextField(title: "Email", text: $email, required: true)
                            .textInputAutocapitalization(.never)
                        LoginTextField(title: "Password", text: $password, required: true, isSecure: true)
                        
                        // Forgot Password
                        NavigationLink(destination: Forgotpassword()) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(primaryColor)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 20)
                    
                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }
                    
                    // Login Button
                    Button(action: {
                        loginUser()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryColor)
                                .cornerRadius(20)
                        }
                    }
                    .disabled(isLoading)
                    .padding(.horizontal, 65)
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $loginSuccess) {
                Homepage()
            }
        }
    }
    
    struct LoginTextField: View {
        let title: String
        @Binding var text: String
        var required: Bool = false
        var isSecure: Bool = false

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    if required {
                        Text("*")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }

                if isSecure {
                    SecureField("", text: $text)
                        .textFieldStyle(LoginTextFieldStyle())
                } else {
                    TextField("", text: $text)
                        .textFieldStyle(LoginTextFieldStyle())
                }
            }
        }
    }

    struct LoginTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .frame(height: 50)
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }


    // Function to call API
    private func loginUser() {
        isLoading = true
        errorMessage = nil

        let parameters = [
            "email": email,
            "password": password
        ]

        APIService.shared.sendPostRequest(url: APIList.login, parameters: parameters) { (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    
                    //Debug prints
                    print("Full response: \(response)")
                    print("Status: \(response.status)")
                    print("Message: \(response.message)")
                    print("Data:{ \(String(describing: response.data))}")
                    
                    if response.status == "True" {
                        Constants.loginResponse = response
//                        if let userData = response.data {
////                            self.userSession.userID = userData.user_id
////                            self.userSession.userName = userData.name
////                            self.userSession.isLoggedIn = true
//                        }
                        self.loginSuccess = true
                    } else {
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status, message: String
    let data: LoginData

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - DataClass
struct LoginData: Codable {
    let userID, name, email: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, email
    }
}


// Struct matching PHP response
//struct LoginResponse: Decodable {
//    let status: Bool
//    let message: String
//    let data: LoginData
//
//    enum CodingKeys: String, CodingKey {
//        case status = "Status"
//        case message = "Message"
//        case data = "Data"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let statusString = try container.decode(String.self, forKey: .status)
//        self.status = statusString.lowercased() == "true"
//        self.message = try container.decode(String.self, forKey: .message)
//        self.data = try? container.decode(LoginData.self, forKey: .data)
//    }
//}
//
//struct LoginData: Decodable {
//    let user_id: Int
//    let name: String
//    let email: String
//}

#Preview {
    LoginView()
        .environmentObject(UserSession())
}
