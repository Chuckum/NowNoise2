import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("What are you listening to?", text: $viewModel.songName)
                    
                    Picker("Genre", selection: $viewModel.selectedGenre) {
                        Text("Select Genre").tag(Optional<String>.none)
                        ForEach(viewModel.genres, id: \.self) { genre in
                            Text(genre).tag(Optional(genre))
                        }
                    }
                }
                
                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $viewModel.selectedItem,
                               matching: .images) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Label("Add Photo", systemImage: "photo")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            await viewModel.createPost()
                            dismiss()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Share NowNoise")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.songName.isEmpty || viewModel.isLoading)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

class CreatePostViewModel: ObservableObject {
    @Published var songName = ""
    @Published var selectedGenre: String?
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isLoading = false
    
    let genres = ["Pop", "Rock", "Hip Hop", "R&B", "Electronic", "Jazz", "Classical", "Country"]
    
    init() {
        setupPhotoPicker()
    }
    
    private func setupPhotoPicker() {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = image
                }
            }
        }
    }
    
    func createPost() async {
        await MainActor.run {
            isLoading = true
        }
        
        var imageURL: String?
        
        if let image = selectedImage {
            let postId = UUID().uuidString
            imageURL = StorageManager.shared.saveImage(image, for: postId)
        }
        
        let post = Post(
            songName: songName,
            timestamp: Date(),
            imageURL: imageURL,
            genre: selectedGenre
        )
        
        var posts = StorageManager.shared.loadPosts()
        posts.insert(post, at: 0)
        StorageManager.shared.savePosts(posts)
        
        await MainActor.run {
            isLoading = false
        }
    }
} 