import SwiftUI

struct AnimeDetailView: View {
    let title: String
    let imageName: String
    let id: String
    let episode: String
    let trailerUrl: String
    @State private var genres: String = ""
    @State private var description: String = ""
    @State private var rating: String = ""
    
    //Example data
    @State var episodes: [EpisodeData] = [
        EpisodeData(episodeNumber: 01, title: "The Beginning", type: .canon)
        
    ]
    @State private var showWebView = false
    private let columns = [
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 120)),
        GridItem(.flexible(minimum: 100))
    ]
    
    private func getTypeColor(_ type: String) -> Color {
        switch type {
        case "canon":
            return ThemeColors.canon
        case "filler":
            return ThemeColors.filler
        case "mixed canon/filler":
            return ThemeColors.MixedCanonFiller
        default:
            return ThemeColors.primary
        }
    }
    
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView{
                VStack {
                    HStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(15)
                        VStack {
                            Text(title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .frame(width: 12, height: 12)
                                Text("\(rating)/10")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Text(genres)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            HStack {
                                
                                Button(action: {
                                    showWebView = true
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                        .background(Circle().fill(Color.white.opacity(0.6)))
                                }.sheet(isPresented: $showWebView) {
                                    WebView(urlString: trailerUrl).edgesIgnoringSafeArea(.all)
                                }
                                
                                Text("Watch Trailer")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    
                                // Adjust position inside the image
                            }
                        }
                    }
                    Text(description)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        Text("Episode number")
                            .font(.headline)
                            .foregroundColor(ThemeColors.primary)
                            .frame(maxWidth: .infinity)
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(ThemeColors.primary)
                            .frame(maxWidth: .infinity)
                        Text("Type")
                            .font(.headline)
                            .foregroundColor(ThemeColors.primary)
                            .frame(maxWidth: .infinity)
                        
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .background(Color.gray.opacity(0.3))
                    
                    //Episode List
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())
                                       ], spacing: 10) {
                        ForEach(episodes, id: \.episodeNumber) { episode in
                            Text("\(episode.episodeNumber)") // Episode number
                                .foregroundColor(.white)
                            
                            Text(episode.title) // Episode title
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(episode.type.rawValue) // Convert enum to String
                                .foregroundColor(getTypeColor(episode.type.rawValue.lowercased()))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(getTypeColor(episode.type.rawValue.lowercased()).opacity(0.2))
                                .cornerRadius(6)
                        }
                        
                        
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                
            }
            
            .padding()
        }.onAppear(perform: {
            fetchDetails()
        })
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func fetchDetails() {
        //
        let param = ["anime_id": id]
        
        APIHandler.shared.postAPIValues(type: AnimeDetailModel.self, apiUrl: "http://localhost/Animeverse_Backend/getanime.php", method: "POST", formData: param) { result in
            switch result {
            case .success(let data):
                print(data)
                if data.status == "True" {
                    self.episodes = data.data.episodes
                    self.description = data.data.description
                    self.rating = data.data.rating
                    self.genres = data.data.genres
                } else {
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
struct AnimeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeDetailView(title: "Attack on Titan", imageName: "Attack_On_Titan", id: "12", episode: "My Hero Academia", trailerUrl: "https://youtu.be/MGRm4IzK1SQ?feature=shared")
    }
}
