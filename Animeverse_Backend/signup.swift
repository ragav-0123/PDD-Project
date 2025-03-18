import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToLogin = false // 👈 Controls navigation

    private let primaryColor = Color(hex: "EC5408")

    @Environment(\.presentationMode) var presentationMode

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
                        CustomTextField(title: "Name", text: $name, required: true)
                        CustomTextField(title: "Age", text: $age, required: true)
                        CustomTextField(title: "Email", text: $email, required: true)
                        CustomTextField(title: "Password", text: $password, required: true, isSecure: true)
                    }
                    .padding(.horizontal, 20)

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }

                    // Register Button
                    Button(action: {
                        registerUser()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Register")
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
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()   // 👈 Navigates to login page when true
            }
        }
    }
    
    struct CustomTextField: View {
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
                        .textFieldStyle(CustomTextFieldStyle())
                } else {
                    TextField("", text: $text)
                        .textFieldStyle(CustomTextFieldStyle())
                }
            }
        }
    }

    struct CustomTextFieldStyle: TextFieldStyle {
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


    // Function to register user using APIService
    private func registerUser() {
        isLoading = true
        errorMessage = nil

        let parameters = [
            "name": name,
            "age": age,
            "email": email,
            "password": password
        ]

        APIService.shared.sendPostRequest(url: APIList.signUp, parameters: parameters) { (result: Result<SignUpResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        self.navigateToLogin = true // ✅ Navigate to LoginView on success
                    } else {
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct SignUpResponse: Decodable {
    let status: Bool
    let message: String
    var data: SignupData?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let statusString = try container.decode(String.self, forKey: .status)
        self.status = statusString.lowercased() == "true"
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try? container.decode(SignupData.self, forKey: .data)
        
        if let SignupData = try? container.decode(SignupData.self, forKey: .data) {
                    self.data = SignupData
                } else {
                    self.data = nil
                }
    }
}

struct SignupData: Decodable {
    let user_id: Int
    let name: String
    let email: String
}


#Preview {
    SignupView()
}
