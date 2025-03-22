import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            PostCardView(post: post)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("NowNoise")
            .onAppear {
                viewModel.loadPosts()
            }
        }
    }
}

struct PostCardView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = post.imageURL,
               let image = StorageManager.shared.loadImage(for: post.id) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 150)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.songName)
                    .font(.headline)
                    .lineLimit(1)
                
                if let genre = post.genre {
                    Text(genre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(post.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func loadPosts() {
        posts = StorageManager.shared.loadPosts()
    }
} 