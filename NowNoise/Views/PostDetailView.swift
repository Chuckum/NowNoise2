import SwiftUI

struct PostDetailView: View {
    let post: Post
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = post.imageURL,
                   let image = StorageManager.shared.loadImage(for: post.id) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.songName)
                        .font(.title)
                        .bold()
                    
                    if let genre = post.genre {
                        Text(genre)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(post.timestamp, style: .relative)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
} 