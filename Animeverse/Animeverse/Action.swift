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
                                            toggleFavorite(id: item.id)
                                        }) {
                                            Image(systemName: isFavorite(animeId: item.id) ? "heart.fill" : "heart")
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
            .onAppear {
                fetchFavoritesFromBackend()
            }
        }
    }

    // Check if an item is in favorites
    private func isFavorite(animeId: String) -> Bool {
        return favourites.contains(animeId)
    }
    
    // Toggle favorite status and update backend
    private func toggleFavorite(id: String) {
        if favourites.contains(id) {
            // Remove from favorites
            print("Removing anime ID \(id) from favorites")
            removeFromFavorites(animeId: id)
        } else {
            // Add to favorites
            print("Adding anime ID \(id) to favorites")
            addToFavorites(animeId: id)
        }
    }
    
    // Fetch all favorites from backend on view appear
    private func fetchFavoritesFromBackend() {
        guard let userId = Constants.loginResponse?.data.userID else {
            print("User ID not found in Constants")
            return
        }
        
        guard let url = URL(string: APIList.GetFavorites) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = "user_id=\(userId)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching favorites: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from favorites API")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["Status"] as? String,
                   status == "True",
                   let dataArray = json["Data"] as? [[String: Any]] {
                    
                    // Extract anime IDs from the response
                    let animeIds = dataArray.compactMap { $0["anime_id"] as? String }
                    
                    DispatchQueue.main.async {
                        self.favourites = Set(animeIds)
                        print("Fetched \(animeIds.count) favorites")
                    }
                } else {
                    print("Invalid response format or empty favorites")
                }
            } catch {
                print("Error parsing favorites JSON: \(error)")
            }
        }.resume()
    }
    
    // Add to favorites in backend
    private func addToFavorites(animeId: String) {
        guard let userId = Constants.loginResponse?.data.userID else {
            print("User ID not found in Constants")
            return
        }
        
        guard let url = URL(string: APIList.AddFavorite) else {
                print("Invalid API URL")
                return
        }

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = "user_id=\(userId)&anime_id=\(animeId)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding favorite: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                return
            }
            
            // Print raw server response
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw API Response:", rawResponse)
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["Status"] as? String {
                    
                    if status == "True" {
                        DispatchQueue.main.async {
                            self.favourites.insert(animeId)
                            print("Successfully added to favorites")
                        }
                    } else {
                        print("Failed to add to favorites: \(json["Message"] as? String ?? "Unknown error")")
                    }
                }
            } catch {
                print("Error parsing add favorite response: \(error)")
            }
        }.resume()
    }
    
    // Remove from favorites in backend
    private func removeFromFavorites(animeId: String) {
        guard let userId = Constants.loginResponse?.data.userID else {
            print("User ID not found in Constants")
            return
        }

        
        guard let url = URL(string: APIList.RemoveFavorite) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters = "user_id=\(userId)&anime_id=\(animeId)"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error removing favorite: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["Status"] as? String {
                    
                    if status == "True" {
                        DispatchQueue.main.async {
                            self.favourites.remove(animeId)
                            print("Successfully removed from favorites")
                        }
                    } else {
                        print("Failed to remove from favorites: \(json["Message"] as? String ?? "Unknown error")")
                    }
                }
            } catch {
                print("Error parsing remove favorite response: \(error)")
            }
        }.resume()
    }
}

// Preview
struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
    }
}
