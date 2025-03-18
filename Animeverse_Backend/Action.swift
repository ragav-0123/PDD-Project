import SwiftUI

struct ActionView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    // Anime list with ID, imageName, and title
    let items: [(sno: Int, id: String, imageName: String, title: String, trailerURL: String)] = [
        (1, "12", "Attack_On_Titan", "Attack on Titan", "https://youtu.be/MGRm4IzK1SQ?feature=shared"),
        (2, "2", "mha", "My Hero Academia", "https://youtu.be/EPVkcwyLQQ8?feature=shared"),
        (3, "14", "demon_slayer", "Demon Slayer", "https://youtu.be/VQGCKyvzIM4?feature=shared"),
        (4, "1", "naruto", "Naruto", "https://youtu.be/-G9BqkgZXRA?feature=shared"),
        (5, "11", "Bleach", "Bleach", "https://youtu.be/mnFXQUq-7ks?feature=shared"),
        (6, "6", "one_piece", "One Piece", "https://youtu.be/MCb13lbVGE0?feature=shared"),
        (7, "7", "tokyo_ghoul", "Tokyo Ghoul", "https://youtu.be/UUeqpuZobBw?feature=shared"),
        (8, "8", "black_clover", "Black Clover", "https://youtu.be/QwNWY6z93O4?feature=shared"),
        (9, "9", "fairy_tail", "Fairy Tail", "https://youtu.be/4KSN7mxhiYE?feature=shared"),
        (10, "19", "dragon_ball", "Dragon Ball", "")
    ]
    
    @State private var favourites: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0) {
                    // Custom Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(primaryColor)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    // Title
                    Text("Action")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.bottom, 20)
                    
                    // Scrollable List
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(items, id: \.id) { item in
                                NavigationLink(destination: AnimeDetailView(
                                    title: item.title,
                                    imageName: item.imageName,
                                    id: item.id, // Passed but not displayed
                                    episode: "1",trailerUrl: item.trailerURL
                                )) {
                                    HStack(spacing: 10) {
                                        // Serial Number
                                        Text("\(item.sno)")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 40, alignment: .leading)
                                        
                                        ZStack{
                                            // Anime Image
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 180, height: 180)
                                                .clipped()
                                                .cornerRadius(15)
//                                            Button(action: {
//                                                if let url = URL(string: item.trailerURL) {
//                                                    UIApplication.shared.open(url)
//                                                }
//                                            }) {
//                                                Image(systemName: "play.circle.fill")
//                                                    .font(.system(size: 40))
//                                                    .foregroundColor(.blue)
//                                                    .background(Circle().fill(Color.white.opacity(0.6)))
//                                            }
//                                            .offset(y: 65) // Adjust position inside the image
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            // Title
                                            Text(item.title)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                            
                                            // Hidden ID (for backend use only)
                                            Text(item.id)
                                                .hidden() // Hide ID from UI but pass it in NavigationLink
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        Button(action: {
                                            toggleFavorite(imageName: item.imageName)
                                        }) {
                                            Image(systemName: isFavorite(imageName: item.imageName) ? "heart.fill" : "heart")
                                                .font(.title2)
                                                .foregroundColor(primaryColor)
                                                .padding(10)
                                                .background(Color.white.opacity(0.1))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.vertical, 10)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // Check if an item is in favorites
    private func isFavorite(imageName: String) -> Bool {
        return favourites.contains(imageName)
    }
    
    // Toggle favorite status
    private func toggleFavorite(imageName: String) {
        if favourites.contains(imageName) {
            favourites.remove(imageName)
            print("Removed from Favorites: \(imageName)")
        } else {
            favourites.insert(imageName)
            print("Added to Favorites: \(imageName)")
        }
    }
}

// Preview
struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
