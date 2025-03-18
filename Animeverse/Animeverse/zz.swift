import SwiftUI

struct Anime: Identifiable, Decodable {
    let id = UUID()
    let mal_id: Int
    let title: String
    let images: ImageData
    let score: Double?

    struct ImageData: Decodable {
        let jpg: JpgImage
    }
    
    struct JpgImage: Decodable {
        let image_url: String
    }
}

struct AnimeResponse: Decodable {
    let data: [Anime]
}

class AnimeViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    
    func fetchAnime() {
        guard let url = URL(string: "https://api.jikan.moe/v4/top/anime?adventure") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.animes = decodedResponse.data
                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
}

struct ZZView: View {
    @StateObject private var viewModel = AnimeViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.animes) { anime in
                        NavigationLink(destination: DetailView(malID: anime.mal_id)) {
                            Card(anime: anime)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Top Adventure Anime")
        }
        .onAppear {
            viewModel.fetchAnime()
        }
    }
}

struct Card: View {
    let anime: Anime
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                image.resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            
            Text(anime.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 5)
            
            if let score = anime.score {
                Text("⭐ \(score, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// MARK: - Anime Detail View
struct DetailView: View {
    let malID: Int
    @State private var animeDetails: AnimeDetail?
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading Anime Details...")
                    .padding()
            } else if let anime = animeDetails {
                VStack(alignment: .leading, spacing: 10) {
                    AsyncImage(url: URL(string: anime.images.jpg.image_url)) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                    .padding(.bottom, 10)
                    
                    Text(anime.title)
                        .font(.title)
                        .bold()
                    
                    if let score = anime.score {
                        Text("⭐ Rating: \(score, specifier: "%.1f")")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                    
                    Text("Synopsis")
                        .font(.headline)
                        .padding(.top, 5)
                    
                    Text(anime.synopsis ?? "No synopsis available")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
            } else {
                Text("Failed to load anime details. Try again later.")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Anime Details")
        .onAppear {
            fetchAnimeDetails()
        }
    }
    
    func fetchAnimeDetails() {
        guard let url = URL(string: "https://api.jikan.moe/v4/anime/\(malID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(AnimeDetail.self, from: data)
                DispatchQueue.main.async {
                    self.animeDetails = decodedResponse
                    self.isLoading = false
                }
            } catch {
                print("Detail decoding error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

// MARK: - Anime Detail Model
struct AnimeDetail: Decodable {
    let mal_id: Int
    let title: String
    let images: Anime.ImageData
    let synopsis: String?
    let score: Double?
    let url: String
    let trailer: Trailer?
    
    struct Trailer: Decodable {
        let youtube_id: String?
        let url: String?
    }
}

// MARK: - Preview
struct ZZView_Previews: PreviewProvider {
    static var previews: some View {
        ZZView()
    }
}
