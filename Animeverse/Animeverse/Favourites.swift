import SwiftUI

struct FavouritesView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    @State private var favouriteItems: [FavoriteItem] = []
    @State private var isRefreshing = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Favourites")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                        
                        Spacer()
                        
                        Button(action: {
                            isRefreshing = true
                            fetchFavorites()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(primaryColor)
                                .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                                .animation(isRefreshing ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    if favouriteItems.isEmpty {
                        Spacer()
                        VStack {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("No favourites added yet!")
                                .foregroundColor(.gray)
                                .font(.title3)
                            
                            Text("Go to Action page to add some anime to your favorites")
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .padding(.top, 5)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 15) {
                                ForEach(favouriteItems) { item in
                                    HStack {
                                        // Find matching image name from ActionView's items list
                                        Image(getImageName(for: item.animeId) ?? "placeholder_image")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.animeName)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 2)
                                            
                                            if !item.genres.isEmpty {
                                                Text(item.genres)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            HStack {
                                                Text("Episodes: \(item.totalEpisodes)")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                
                                                NavigationLink(destination: AnimeDetailView(
                                                    title: item.animeName,
                                                    imageName: getImageName(for: item.animeId) ?? "placeholder_image",
                                                    id: item.animeId,
                                                    episode: "1",
                                                    trailerUrl: ""
                                                )) {
                                                    Text("View Details")
                                                        .font(.caption)
                                                        .foregroundColor(primaryColor)
                                                        .padding(.vertical, 4)
                                                        .padding(.horizontal, 10)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(primaryColor, lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            removeFromFavorites(animeId: item.animeId)
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(primaryColor)
                                                .padding(8)
                                                .background(
                                                    Circle()
                                                        .fill(Color.white.opacity(0.1))
                                                )
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .onAppear {
                fetchFavorites()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Helper function to get image name from anime ID
    private func getImageName(for animeId: String) -> String? {
        let items: [(id: String, imageName: String)] = [
            //Action
            ("12", "Attack_On_Titan"),
            ("2", "mha"),
            ("14", "demon_slayer"),
            ("1", "naruto"),
            ("11", "Bleach"),
            ("1", "one_piece"),
            ("7", "tokyo_ghoul"),
            ("8", "black_clover"),
            ("9", "fairy_tail"),
            ("19", "dragon_ball"),
            
            //Adeventure
            ("1", "one_piece"),
            ("21", "hunter_x_hunter"),
            ("20", "Made_In_Abyss"),
            ("12", "Attack_On_Titan"),
            ("23", "fullmental_alchemist_brotherhood"),
            ("25", "Magi_The_Labyrinth_Of_Magic"),
            ("24", "dr_stone"),
            ("8", "black_clover"),
            ("22", "solo_leveling"),
            ("27", "The_Rising_of_the_Shield_Hero"),
            
            //Comedy
            ("26", "kaguya_sama_love_is_war"),
            ("12", "disastrous_life_of_saikik"),
            ("17", "Gintama"),
            ("16", "one_punch_man"),
            ("29", "nichijou_my_ordinary_life"),
            ("15", "konosuba_gods_blessing_on_the_wonderful_world"),
            ("30", "daily_lifes_of_high_school_boys"),
            ("32", "you_heard?_iam_sakamoto"),
            ("3", "beelzebub"),
            ("20", "Barakamon"),
            
            //Drama
            ("6", "your_lie_in_april"),
            ("31", "Haikyuu"),
            ("7", "Violet_Evergarden"),
            ("10", "Silver_Spoon"),
            ("33", "The_Aquatope_on_White_Sand"),
            ("26", "Barakamon"),
            ("27", "Non_Non_Biyori"),
            ("28", "Natsume_Book_of_Friends"),
            ("9", "beelzebub"),
            ("8", "March_Comes_in_like_a_Lion"),
            
            //Fantasy
            ("34", "Log_Horizon"),
            ("36", "Yu_Yu_Hakusho"),
            ("38", "That_Time_I_got_Reincarnated_as_a_Slime"),
            ("39", "The_Seven_Deadly_Sins"),
            ("35", "Inuyasha"),
            ("40", "The_Misfit_of_the_Demon_King_Academy"),
            ("37", "Little_Witch_Academia"),
            ("38", "The_Irregular_at_Magic_High_School"),
            ("4", "Overlord"),
            ("5", "Wiseman's_Grandchild"),
            
        ]
        
        return items.first(where: { $0.id == animeId })?.imageName
    }
    
    private func fetchFavorites() {
        guard let userId = Constants.loginResponse?.data.userID else {
            self.errorMessage = "User ID not found. Please log in again."
            self.showErrorAlert = true
            self.isRefreshing = false
            return
        }
        
        guard let url = URL(string: APIList.GetFavorites) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = "user_id=\(userId)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isRefreshing = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                    self.showErrorAlert = true
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["Status"] as? String {
                    
                    if status == "True", let dataArray = json["Data"] as? [[String: Any]] {
                        let items = dataArray.compactMap { dict -> FavoriteItem? in
                            guard
                                let favoriteId = dict["favorite_id"] as? String,
                                let animeId = dict["anime_id"] as? String,
                                let animeName = dict["anime_name"] as? String
                            else {
                                return nil
                            }
                            
                            let genres = dict["genres"] as? String ?? ""
                            let totalEpisodes = dict["total_episodes"] as? String ?? "0"
                            
                            return FavoriteItem(
                                favoriteId: favoriteId,
                                animeId: animeId,
                                animeName: animeName,
                                genres: genres,
                                totalEpisodes: totalEpisodes
                            )
                        }
                        
                        DispatchQueue.main.async {
                            self.favouriteItems = items
                        }
                    } else {
                        DispatchQueue.main.async {
                            // If no favorites found, just set empty array without showing error
                            if let message = json["Message"] as? String, message.contains("No favorites") {
                                self.favouriteItems = []
                            } else {
                                self.errorMessage = json["Message"] as? String ?? "Failed to retrieve favorites"
                                self.showErrorAlert = true
                            }
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing server response: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
    
    private func removeFromFavorites(animeId: String) {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else { return }
        
        guard let url = URL(string: APIList.RemoveFavorite) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = "user_id=\(userId)&anime_id=\(animeId)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["Status"] as? String {
                    
                    if status == "True" {
                        DispatchQueue.main.async {
                            // Remove from local list
                            self.favouriteItems.removeAll { $0.animeId == animeId }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = json["Message"] as? String ?? "Failed to remove from favorites"
                            self.showErrorAlert = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing server response: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
}

// Model to represent favorite items
struct FavoriteItem: Identifiable {
    let id = UUID()
    let favoriteId: String
    let animeId: String
    let animeName: String
    let genres: String
    let totalEpisodes: String
}

// Preview
struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
