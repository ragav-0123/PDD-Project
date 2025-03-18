import SwiftUI

struct FavouritesView: View {
    private let primaryColor = Color(hex: "EC5408")
    
    @State private var favouriteItems: [(id: String, imageName: String, title: String)] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Favourites")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.top, 20)
                    
                    if favouriteItems.isEmpty {
                        Text("No favourites added yet!")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 15) {
                                ForEach(favouriteItems, id: \.id) { item in
                                    HStack {
                                        Image(item.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        Text(item.title)
                                            .font(.title3)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                fetchFavorites()
            }
        }
    }
    
    private func fetchFavorites() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
        
        struct FavoriteAnime: Codable {
            let id: String
            let imageName: String
            let title: String
        }

        
        let url = URL(string: APIList.GetFavorites)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "userID=\(userID)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data, let response = try? JSONDecoder().decode([FavoriteAnime].self, from: data) {
                DispatchQueue.main.async {
                    self.favouriteItems = response.map { ($0.id, $0.imageName, $0.title) }
                }
            }
        }.resume()
    }
}
