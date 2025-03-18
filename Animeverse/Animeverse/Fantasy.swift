import SwiftUI

struct FantasyView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    // Anime list with ID, imageName, and title
    let items: [(sno: Int, id: String, imageName: String, title: String, trailerURL: String)] = [
        (1, "34", "Log_Horizon", "Log Horizon", "https://youtu.be/IG1VhJ75r8k?feature=shared"),
        (2, "36", "Yu_Yu_Hakusho", "Yu Yu Hakusho", "https://youtu.be/bGc1Na8mlw0?feature=shared"),
        (3, "38", "That_Time_I_got_Reincarnated_as_a_Slime", "That Time I Got Reincarnated as a Slime", "https://youtu.be/uOzwqb74K34?feature=shared"),
        (4, "39", "The_Seven_Deadly_Sins", "The Seven Deadly Sins", "https://youtu.be/wxcvbL6o55M?feature=shared"),
        (5, "35", "Inuyasha", "Inuyasha", "https://youtu.be/UCFBsLagBPk?feature=shared"),
        (6, "40", "The_Misfit_of_the_Demon_King_Academy", "The Misfit of Demon King Academy", "https://youtu.be/9qJyDlZst8c?feature=shared"),
        (7, "37", "Little_Witch_Academia", "Little Witch Academia", "https://youtu.be/O3RaHXSeUG8?feature=shared"),
        (8, "38", "The_Irregular_at_Magic_High_School", "The Irregular at Magic High School", "https://youtu.be/U-gkwdGooDU?feature=shared"),
        (9, "4", "Overlord", "Overlord", "https://youtu.be/uhlBqFj9kDw?feature=shared"),
        (10, "5", "Wiseman's_Grandchild", "Wise Man's Grandchild", "https://youtu.be/gy-78Y-chds?feature=shared")
    ]
    
    @State private var favourites: Set<String> = [] // Track favorited anime by image name
    @Environment(\.presentationMode) var presentationMode // For custom back button
    
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
                    Text("Fantasy")
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
                                    episode: "1",trailerUrl:"" // Placeholder, update if needed
                                )) {
                                    HStack(spacing: 10) {
                                        // Serial Number
                                        Text("\(item.sno)")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 40, alignment: .leading)
                                        
                                        // Anime Image
                                        Image(item.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 180, height: 180)
                                            .clipped()
                                            .cornerRadius(15)
                                        
                                        VStack(alignment: .leading) {
                                            // Title
                                            Text(item.title)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                            
                                            // Hidden ID (for backend use only)
                                            Text(item.id)
                                                .hidden() // Hide ID in UI but pass it to `AnimeDetailView`
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // Heart Button for Favorites
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
struct FantasyView_Previews: PreviewProvider {
    static var previews: some View {
        FantasyView()
    }
}
