import SwiftUI

struct DiscussionView: View {
    @State private var newPost: String = "" // Holds the user's input for a new post
    @StateObject private var viewModel = DiscussionViewModel() // Manages discussion data
    
    private let primaryColor = Color(hex: "EC5408") // Primary color for theming
    var dummyPostData: [Post] = [Post(id: 1, content: "Animeverse.EpisodeData(Animeverse.EpisodeDataAnimeverse.EpisodeData", likes: 5),Post(id: 1, content: "Animeverse.EpisodeData(", likes: 5),Post(id: 1, content: "Animeverse.EpisodeData(", likes: 2),Post(id: 1, content: "Animeverse.Animeverse.EpisodeDataAnimeverse.EpisodeDataAnimeverse.EpisodeDataAnimeverse.EpisodeDataAnimeverse.EpisodeDataEpisodeData(", likes: 55)]
    @Environment(\ .presentationMode) var presentationMode // Handles navigation back
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea() // Black background for the entire screen
                
                VStack(spacing: 20) {
                    // Back Button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Navigate back
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(primaryColor)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // Title Below Back Button
                    Text("Crew Discuss") // Title of the page
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .padding(.top, 10)
                    
                    Spacer()
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(dummyPostData) { post in
                                HStack {
                                    Text("post.content")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.1)) // Background styling
                                        .cornerRadius(15)
                                    
                                    Button(action: {
                                        viewModel.likePost(postId: post.id) // Like button action
                                    }) {
                                        HStack {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red) // Red heart icon
                                            Text("\(post.likes)")
                                                .foregroundColor(.white) // Display like count
                                        }
                                        .padding(.trailing, 20)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }
                    // Post Input Field in the Middle
                    HStack {
                        TextField("Write something...", text: $newPost)
                            .padding()
                            .background(Color.white.opacity(0.1)) // Slight background contrast
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .frame(height: 50)
                        
                        Button(action: {
                            viewModel.addPost(content: newPost) // Add post to the discussion
                            newPost = "" // Clear input field after posting
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding()
                                .background(primaryColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Discussion List
                    
                    
                    Spacer()
                }
            }
            .onAppear {
                viewModel.fetchPosts() // Fetch posts when the view appears
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}

// ViewModel for Handling Data
class DiscussionViewModel: ObservableObject {
    @Published var posts: [Post] = [] // Stores discussion posts
    
    func fetchPosts() {
        // Fetch posts from backend (to be implemented)
    }
    
    func addPost(content: String) {
        // Send post to backend (to be implemented)
    }
    
    func likePost(postId: Int) {
        // Send like update to backend (to be implemented)
    }
}

// Post Model
struct Post: Identifiable, Decodable {
    let id: Int
    let content: String
    var likes: Int
}

struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionView()
    }
}
