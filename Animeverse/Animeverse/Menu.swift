import SwiftUI

struct MenuView: View {
    // Using the same primary color as LoginView and SignupView
    private let primaryColor = Color(hex: "EC5408")
    
    @Environment(\.presentationMode) var presentationMode // To handle back navigation
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 20) {
                    // Custom Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(primaryColor)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // Header
                    Text("ANIMEVERSE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    // Profile Options
                    VStack(spacing: 30) {
                        NavigationLink(destination: GenresView()) {
                            MenuOptionButton(title: "Genres")
                        }
                        MenuOptionButton(title: "Recommandations")
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true) // Hide default back button
        }
    }
}

// Profile Option Button Component
struct MenuOptionButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

// Preview
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuView()
        }
    }
}
