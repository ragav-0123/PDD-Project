import SwiftUI

struct OnBoard: View {
    var body: some View {
        NavigationStack{
            ZStack {
                // Background color for the whole screen
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Title
                    Text("ANIMEVERSE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "EC5408"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 150)
                    
                    Spacer()
                    
                    // Buttons
                    HStack(spacing: 30) {
                        // Sign Up Button
                        NavigationLink(destination: SignupView()) {
                            Text("Sign Up")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 147, height: 68)
                                .background(Color(hex: "EC5408"))
                                .cornerRadius(40)
                        }
                        
                        // Login Button
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 147, height: 68)
                                .background(Color(hex: "EC5408"))
                                .cornerRadius(40)
                        }
                    }
                    .padding(.bottom, 230) // Reduced from 200 to 100
                    
                    Spacer()
                        .frame(height: 50) // Added extra space at the bottom
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoard()
    }
}
