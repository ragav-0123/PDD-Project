import SwiftUI

struct Forgotpassword: View {
    @State private var email: String = ""
    @State private var newpassword: String = ""
    @State private var confirmpassword: String = ""
    @State private var isLoading = false
    @State private var successMessage: String?
    @State private var errorMessage: String?

    private let primaryColor = Color(hex: "EC5408")

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                // Back Button & Title
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(primaryColor)
                    }
                    Spacer()
                    Text("ANIMEVERSE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                VStack(spacing: 25) {
                    ForgotTextField(title: "Email", text: $email, required: true)
                    ForgotTextField(title: "New Password", text: $newpassword, required: true, isSecure: true)
                    ForgotTextField(title: "Confirm Password", text: $confirmpassword, required: true, isSecure: true)
                }
                .padding(.horizontal, 20)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                Button(action: resetPassword) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Submit")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 65)
                .padding(.top, 40)
                .disabled(isLoading)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    // Function to send forgot password request
    func resetPassword() {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        // Validate input
        guard !email.isEmpty, !newpassword.isEmpty, !confirmpassword.isEmpty else {
            errorMessage = "All fields are required."
            isLoading = false
            return
        }

        guard newpassword == confirmpassword else {
            errorMessage = "Passwords do not match."
            isLoading = false
            return
        }

        // Prepare API request parameters
        let parameters = [
            "email": email,
            "newpassword": newpassword,
            "confirmpassword": confirmpassword
        ]

        APIService.shared.sendPostRequest(url: APIList.forgotPassword, parameters: parameters) { (result: Result<ForgotPasswordResponse, Error>) in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        successMessage = "Password reset successfully."
                    } else {
                        errorMessage = response.message
                    }
                case .failure(let error):
                    errorMessage = "Failed to reset password: \(error.localizedDescription)"
                }
            }
        }
    }
}

// Custom TextField for Forgot Password
struct ForgotTextField: View {
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
                    Text("*").font(.title2).foregroundColor(.red)
                }
                Spacer()
            }
            if isSecure {
                SecureField("", text: $text)
                    .textFieldStyle(ForgotTextFieldStyle())
            } else {
                TextField("", text: $text)
                    .textFieldStyle(ForgotTextFieldStyle())
            }
        }
    }
}

struct ForgotTextFieldStyle: TextFieldStyle {
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

// Struct to Decode API Response
struct ForgotPasswordResponse: Decodable {
    let status: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let statusString = try container.decode(String.self, forKey: .status)
        self.status = statusString.lowercased() == "true"
        self.message = try container.decode(String.self, forKey: .message)
    }
}

// Preview
struct Forgotpassword_Previews: PreviewProvider {
    static var previews: some View {
        Forgotpassword()
    }
}
