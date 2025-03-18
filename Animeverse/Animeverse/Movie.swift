import SwiftUI

struct MovieView: View {
    private let primaryColor = Color(hex: "EC5408")

    // Movie list with ID, imageName, title, and trailer URL
    let items: [(sno: Int, id: String, imageName: String, title: String, trailerURL: String)] = [
        (1, "41", "A_Whisker_Away", "A Whisker Away", "https://youtu.be/aXc9DVfLTGo"),
        (2, "42", "Wolf_Childrean", "Wolf Children", "https://youtu.be/8xLji7WsW0w"),
        (3, "43", "The_Girl_Who_Lept_through_Time", "The Girl Who Leapt Through Time", "https://youtu.be/BSGdAF8v2CM"),
        (4, "44", "A_Silent_Voice", "A Silent Voice", "https://youtu.be/nfK6UgLra7g"),
        (5, "45", "Your_Name", "Your Name", "https://youtu.be/xU47nhruN-Q"),
        (6, "46", "Grave_of_the_Fireflies", "Grave of the Fireflies", "https://youtu.be/4vPeTSRd580"),
        (7, "47", "I_Want_to_Eat_Your_Pancreas", "I Want to Eat Your Pancreas", "https://youtu.be/ORAbzcwOqRY"),
        (8, "48", "Maquia_When_the_Promised_Flower_Blooms", "Maquia: When the Promised Flower Blooms", "https://youtu.be/kwr79VRmUoY"),
        (9, "49", "5_Centimeters_Per_Second", "5 Centimeters Per Second", "https://youtu.be/wdM7athAem0"),
        (10, "50", "To_the_Forest_of_Firefly_Lights", "To the Forest of Firefly Lights", "https://youtu.be/VqowkDMxTKk")
    ]

    @State private var favourites: Set<String> = [] // Track favorited movies by ID
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
                    Text("Movies")
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

                                        // Movie Image
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

                                            // Hidden ID
                                            Text(item.id)
                                                .hidden()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                        Button(action: {
                                            toggleFavorite(id: item.id)
                                        }) {
                                            Image(systemName: isFavorite(movieId: item.id) ? "heart.fill" : "heart")
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

    // Check if a movie is in favorites
    private func isFavorite(movieId: String) -> Bool {
        return favourites.contains(movieId)
    }

    // Toggle favorite status and update backend
    private func toggleFavorite(id: String) {
        if favourites.contains(id) {
            print("Removing movie ID \(id) from favorites")
            removeFromFavorites(movieId: id)
        } else {
            print("Adding movie ID \(id) to favorites")
            addToFavorites(movieId: id)
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
        request.httpBody = "user_id=\(userId)".data(using: .utf8)
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
                   let status = json["Status"] as? String, status == "True",
                   let dataArray = json["Data"] as? [[String: Any]] {
                    
                    let movieIds = dataArray.compactMap { $0["anime_id"] as? String }

                    DispatchQueue.main.async {
                        self.favourites = Set(movieIds)
                        print("Fetched \(movieIds.count) favorites: \(movieIds)")
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
    private func addToFavorites(movieId: String) {
        // Same function as in DramaView (calls API)
    }

    // Remove from favorites in backend
    private func removeFromFavorites(movieId: String) {
        // Same function as in DramaView (calls API)
    }
}

// Preview
struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
