import SwiftUI

struct AdventureView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    let items: [(sno: Int, id: String, imageName: String, title: String, trailerURL: String)] = [
        (1, "1", "one_piece", "One Piece", "https://youtu.be/MCb13lbVGE0?feature=shared"),
        (2, "21", "hunter_x_hunter", "Hunter x Hunter", "https://youtu.be/d6kBeJjTGnY?feature=shared"),
        (3, "20", "Made_In_Abyss", "Made in Abyss", "https://youtu.be/kqBNQEUI8dM?feature=shared"),
        (4, "12", "Attack_On_Titan", "Attack on Titan", "https://youtu.be/MGRm4IzK1SQ?feature=shared"),
        (5, "23", "fullmental_alchemist_brotherhood", "Fullmetal Alchemist: Brotherhood", "https://youtu.be/AYlksPeSXrs?feature=shared"),
        (6, "25", "Magi_The_Labyrinth_Of_Magic", "Magi: The Labyrinth of Magic", "https://youtu.be/2E7o26G1T0c?feature=shared"),
        (7, "24", "dr_stone", "Dr. Stone", "https://youtu.be/7YZzYeBartM?feature=shared"),
        (8, "8", "black_clover", "Black Clover", "https://youtu.be/QwNWY6z93O4?feature=shared"),
        (9, "22", "solo_leveling", "Solo Leveling", "https://youtu.be/I6JIwjWOhnQ?feature=shared"),
        (10, "27", "The_Rising_of_the_Shield_Hero", "The Rising of the Shield Hero", "https://youtu.be/9TIA-YVv4oA?feature=shared")
    ]
    
    @State private var favourites: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0) {
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
                    
                    Text("Adventure")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(items, id: \ .id) { item in
                                NavigationLink(destination: AnimeDetailView(
                                    title: item.title,
                                    imageName: item.imageName,
                                    id: item.id,
                                    episode: "1",
                                    trailerUrl: item.trailerURL
                                )) {
                                    HStack(spacing: 10) {
                                        Text("\(item.sno)")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 40, alignment: .leading)
                                        
                                        ZStack{
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 180, height: 180)
                                                .clipped()
                                                .cornerRadius(15)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                            
                                            Text(item.id)
                                                .hidden()
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
    
    private func isFavorite(animeId: String) -> Bool {
        return favourites.contains(animeId)
    }
    
    private func toggleFavorite(id: String) {
        if favourites.contains(id) {
            print("Removing anime ID \(id) from favorites")
            removeFromFavorites(animeId: id)
        } else {
            print("Adding anime ID \(id) to favorites")
            addToFavorites(animeId: id)
        }
    }
    
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
                    
                    let animeIds = dataArray.compactMap { $0["anime_id"] as? String }
                    
                    DispatchQueue.main.async {
                        self.favourites = Set(animeIds)
                        print("Fetched \(animeIds.count) favorites")
                    }
                }
            } catch {
                print("Error parsing favorites JSON: \(error)")
            }
        }.resume()
    }
    
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

struct AdventureView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureView()
    }
}
