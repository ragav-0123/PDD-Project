import SwiftUI

struct ChangeprofileView: View {
    @State private var change_name: String = ""
    @State private var change_email: String = ""
    @State private var change_password: String = ""
    @State private var responseMessage: String = ""
    @State private var showAlert = false

    private let primaryColor = Color(hex: "EC5408")

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
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

                Text("ANIMEVERSE")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(primaryColor)
                    .padding(.top, 60)
                    .padding(.bottom, 40)

                VStack(spacing: 25) {
                    ChangeProfileTextField(title: "Change-Name", text: $change_name, required: true)
                    ChangeProfileTextField(title: "Change-Email", text: $change_email, required: true)
                    ChangeProfileTextField(title: "Change-Password", text: $change_password, required: true, isSecure: true)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    updateProfile()
                }) {
                    Text("Change")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 65)
                .padding(.top, 40)

                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Profile Update"), message: Text(responseMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true)
    }

    func updateProfile() {
        guard let url = URL(string: "http://localhost/Animeverse_Backend/changeprofile.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postData = "email=\(change_email)&name=\(change_name)&new_email=\(change_email)&password=\(change_password)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        request.httpBody = postData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.responseMessage = "Failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }

            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["Status"] as? String,
                   let message = json["Message"] as? String {

                    DispatchQueue.main.async {
                        self.responseMessage = message
                        self.showAlert = true
                    }

                    if status == "True" {
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss() // Go back on success
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseMessage = "Error parsing response."
                    self.showAlert = true
                }
            }
        }.resume()
    }
}

// Custom TextField
struct ChangeProfileTextField: View {
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
                    .textFieldStyle(ChangeProfileTextFieldStyle())
            } else {
                TextField("", text: $text)
                    .textFieldStyle(ChangeProfileTextFieldStyle())
            }
        }
    }
}

struct ChangeProfileTextFieldStyle: TextFieldStyle {
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

// Preview
struct ChangeprofileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeprofileView()
        }
    }
}
