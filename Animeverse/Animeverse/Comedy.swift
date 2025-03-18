import SwiftUI

struct ComedyView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    // Anime list with ID, imageName, and title
    let items: [(sno: Int, id: String, imageName: String, title: String, trailerURL: String)] = [
        (1, "26", "kaguya_sama_love_is_war", "Kaguya-sama: Love is War", "https://youtu.be/rZ95aZmQu_8?feature=shared"),
        (2, "12", "disastrous_life_of_saikik", "The Disastrous Life of Saiki K.", "https://youtu.be/RChRfCHWsOI?feature=shared"),
        (3, "17", "Gintama", "Gintama", "https://youtu.be/YQC3ot0RYzW98?feature=shared"),
        (4, "16", "one_punch_man", "One Punch Man", "https://youtu.be/Poo5lqoWSGw?feature=shared"),
        (5, "29", "nichijou_my_ordinary_life", "Nichijou: My Ordinary Life", "https://youtu.be/3bMAMumxt6Q?feature=shared"),
        (6, "15", "konosuba_gods_blessing_on_the_wonderful_world", "KonoSuba: God's Blessing on This Wonderful World!", "https://youtu.be/h4dX58X6ln4?feature=shared"),
        (7, "30", "daily_lifes_of_high_school_boys", "Daily Lives of High School Boys", "https://youtu.be/BsQj0RYzW98?feature=shared"),
        (8, "32", "you_heard?_iam_sakamoto", "Haven’t You Heard? I’m Sakamoto", "https://youtu.be/xpgApmZi7dg?feature=shared"),
        (9, "3", "beelzebub", "Beelzebub", "https://youtu.be/5lyYR7StfrQ?feature=shared"),
        (10, "20", "Barakamon", "Barakamon", "https://youtu.be/1gmN_3kr4wo?feature=shared")
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
                    Text("Comedy")
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
                                    id: item.id,
                                    episode: "1",
                                    trailerUrl: item.trailerURL
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
                                                .hidden()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // Heart Button for Favorites
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
            print("Removing anime ID \(id) from favorites")
            removeFromFavorites(animeId: id)
        } else {
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
struct ComedyView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyView()
    }
}
