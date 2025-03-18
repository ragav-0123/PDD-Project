import SwiftUI

struct Homepage: View {
    
    // Add this property to receive user data
    var userData: LoginData?
    
    private let primaryColor = Color(hex: "EC5408") // Primary theme color
    private let searchIconColor = Color(hex: "ED5509") // Search icon color
    
    @State private var autoScrollTimer: Timer?
    @State private var currentIndex = 0 // Track current tab
    @State private var favourites: [(index: Int, imageName: String)] = [] // Favourites list
    @EnvironmentObject var userSession: UserSession
    @State var openChat = false
    private let animeList = [
        ("NARUTO", "naruto","1"),
        ("DEMON SLAYER", "demon_slayer","14"),
        ("ATTACK ON TITAN", "Attack_On_Titan","12"),
        ("Bleach", "Bleach","11"),
        ("Jujutsu Kaisen", "Jujutsu_Kaisen","13")
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
                            openChat = true
                            
                            print("Search Icon Tapped")
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(searchIconColor)
                        }.sheet(isPresented: $openChat) {
                            Chat()
                           // ChatLoginView(isPresented: .constant(false))
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
                        if let name = Constants.loginResponse?.data.name {
                            Text("Welcome back!! \(name)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        } else {
                            Text("Welcome back!!")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                       
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
                            NavigationLink(destination: AnimeDetailView(title: animeList[index].0, imageName: animeList[index].1, id: animeList[index].2, episode:"",trailerUrl: "")) {
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
                                    NavigationLink(destination: FavouritesView()) {
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
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
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

// Update the preview to handle the optional userData
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Homepage(userData: nil)
    }
}
