import SwiftUI

struct ChatbotWidget: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.gray.opacity(0.3)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    
                    Text("Anime Chatbot")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                
                Text("Ask the necessary questions or doubts regarding anime..!!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: startChat) {
                    Text("Start Chat")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.cornerRadius(12))
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .frame(width: 300, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
    }
    
    func startChat() {
        print("Chat started!") // Replace with actual navigation or action
    }
}

struct ChatbotWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotWidget()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
