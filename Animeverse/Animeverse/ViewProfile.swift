import SwiftUI

struct ViewProfileView: View {
    @State private var user: UserProfile?
    @State private var isLoading = false
    @State private var errorMessage: String?

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

                    // Profile Details
                    if let user = user {
                        VStack(spacing: 25) {
                            ProfileRow(title: "Name", value: user.name)
                            ProfileRow(title: "Age", value: "\(user.age)")
                            ProfileRow(title: "Email", value: user.email)
                        }
                        .padding(.horizontal, 20)
                    } else if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }

                    Spacer()
                }
            }
            .onAppear {
                fetchUserProfile()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    struct ProfileRow: View {
        let title: String
        let value: String

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }

    // Function to fetch user profile from API
    private func fetchUserProfile() {
        guard let userID = Constants.loginResponse?.data.userID else {
            self.errorMessage = "User ID not found"
            return
        }

        isLoading = true
        errorMessage = nil

        let parameters = ["user_id": "\(userID)"]

        APIService.shared.sendPostRequest(url: APIList.ViewProfile, parameters: parameters) { (result: Result<ProfileResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status {
                        self.user = response.data
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

// Model for user profile
struct UserProfile: Decodable {
    let user_id: Int
    let name: String
    let email: String
    let age: Int
}

// Model for API response
struct ProfileResponse: Decodable {
    let status: Bool
    let message: String
    var data: UserProfile?

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
        self.data = try? container.decode(UserProfile.self, forKey: .data)
    }
}

// Preview
#Preview {
    ViewProfileView()
}
