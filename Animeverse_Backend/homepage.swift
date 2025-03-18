import SwiftUI

struct Homepage: View {
    
    private let primaryColor = Color(hex: "EC5408") // Primary theme color
    private let searchIconColor = Color(hex: "ED5509") // Search icon color
    
    @State private var currentIndex = 0 // Track current tab
    @State private var favourites: [(index: Int, imageName: String)] = [] // Favourites list
    
    private let animeList = [
        ("NARUTO", "naruto","1"),
        ("DEMON SLAYER", "demon_slayer","1"),
        ("ATTACK ON TITAN", "Attack_On_Titan","1"),
        ("Bleach", "Bleach",""),
        ("Jujutsu Kaisen", "Jujutsu_Kaisen","")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header with Search Icon
                    HStack {
                        Text("ANIMEVERSE")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                        
                        Spacer()
                        
                        Button(action: {
                            print("Notification Icon Tapped")// Action for notifications
                        }) {
                            Image(systemName: "bell.fill") // SF Symbol for notifications
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(searchIconColor)
                        }
                        
                        Button(action: {
                            print("Search Icon Tapped")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(searchIconColor)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    // Welcome Message
                    HStack(spacing: 10) {
                        Image("John_Doe")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text("Welcome back!! John Doe")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                    
                    // Top Picks Section
                    Text("Top Picks For You")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    // Auto-scrolling Anime Carousel
                    TabView(selection: $currentIndex) {
                        ForEach(0..<animeList.count, id: \.self) { index in
                            NavigationLink(destination: AnimeDetailView(title: animeList[index].0, imageName: animeList[index].1, id: animeList[index].2, episode:"")) {
                                AnimeCard(title: animeList[index].0, imageName: animeList[index].1)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 250)
                    .padding(.horizontal, 20)
                    .onAppear {
                        startAutoScroll()
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation Bar
                    VStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(Color.white.opacity(0.1))
                            .frame(height: 55)
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .overlay(
                                HStack(spacing: 25) {
                                    IconButton(iconName: "Home")
                                        .foregroundColor(.white)
                                    
                                    NavigationLink(destination: DiscussionView()) {
                                        IconButton(iconName: "Group 2992 (1)")
                                    }
                                    NavigationLink(destination: MenuView()) {
                                        IconButton(iconName: "Menu")
                                    }
                                    NavigationLink(destination: FavouritesView(favourites: $favourites)) {
                                        IconButton(iconName: "Favourites")
                                    }
                                    NavigationLink(destination: ProfileView()) {
                                        IconButton(iconName: "Profile")
                                    }
                                }
                            )
                            .padding(.bottom, 10)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Auto-scroll logic
    private func startAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            withAnimation {
                currentIndex = (currentIndex + 1) % animeList.count
            }
        }
    }
}



// Anime Detail View
//Sample Episode
struct Episode {
    let number: String
    let title: String
    let type: String
}


//Theme colour
struct ThemeColors {
    static let background = Color.black
    static let primary = Color(hex: "EC5408") // Better orange
    static let canon = Color(hex: "00796B")   // Teal Green
    static let filler = Color(hex: "D84315")  // Burnt Orange
    static let MixedCanonFiller = Color(hex: "1565C0")   // Brighter Blue
}

struct AnimeDetailView: View {
    let title: String
    let imageName: String
    let id: String
    let episode: String
    
    // Added rating property
    private let rating: String = "8.9/10"
    
    //Example data
    private let episodes: [Episode] = [
            Episode(number: "01", title: "The Beginning", type: "Canon"),
            Episode(number: "02", title: "The Journey Starts", type: "Canon"),
            Episode(number: "03", title: "First Challenge", type: "Canon"),
            Episode(number: "04", title: "New Powers", type: "Canon"),
            Episode(number: "05", title: "The Rival Appears", type: "Filler"),
            Episode(number: "06", title: "Training Arc", type: "Canon"),
            Episode(number: "07", title: "The Tournament", type: "Canon"),
            Episode(number: "08", title: "Hidden Secrets", type: "Mixed"),
            Episode(number: "09", title: "The revelation", type: "Filler"),
            Episode(number: "10", title: "Final Battle", type: "Canon")
        ]
    private let columns = [
            GridItem(.flexible(minimum: 80)),
            GridItem(.flexible(minimum: 120)),
            GridItem(.flexible(minimum: 100))
        ]
    
    private func getTypeColor(_ type: String) -> Color {
            switch type {
            case "Canon":
                return ThemeColors.canon
            case "Filler":
                return ThemeColors.filler
            case "Mixed":
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
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 12, height: 12)
                                Text(rating)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            }
                            
                            Text(id)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                        }
                    }
                    Text("These colors maintain the anime vibe while improving visibility for all users.hese colors maintain the anime vibe while improving visibility for all users.hese colors maintain the anime vibe while improving visibility for all users.")
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
                        ForEach(episodes, id: \.number) { episode in
                                        Text(episode.number)
                                            .foregroundColor(.white)
                                        Text(episode.title)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                        Text(episode.type)
                                            .foregroundColor(getTypeColor(episode.type))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(getTypeColor(episode.type).opacity(0.2))
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
        
    }
}

// Anime Card Component
struct AnimeCard: View {
    let title: String
    let imageName: String
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 240)
                .cornerRadius(10)
                .clipped()
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
        }
        .frame(width: 180, height: 240)
    }
}

// Icon Button Component
struct IconButton: View {
    let iconName: String
    
    var body: some View {
        Image(iconName)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            .padding(5)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
