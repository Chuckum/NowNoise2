import Foundation
import UIKit

class StorageManager {
    static let shared = StorageManager()
    private let postsKey = "posts"
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private init() {}
    
    // MARK: - Posts
    
    func savePosts(_ posts: [Post]) {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: postsKey)
        }
    }
    
    func loadPosts() -> [Post] {
        if let data = UserDefaults.standard.data(forKey: postsKey),
           let posts = try? JSONDecoder().decode([Post].self, from: data) {
            return posts
        }
        return []
    }
    
    // MARK: - Images
    
    func saveImage(_ image: UIImage, for postId: String) -> String? {
        let imageName = "\(postId).jpg"
        let imageURL = documentsDirectory.appendingPathComponent(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: imageURL)
            return imageName
        }
        return nil
    }
    
    func loadImage(for postId: String) -> UIImage? {
        let imageName = "\(postId).jpg"
        let imageURL = documentsDirectory.appendingPathComponent(imageName)
        
        if let imageData = try? Data(contentsOf: imageURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func deleteImage(for postId: String) {
        let imageName = "\(postId).jpg"
        let imageURL = documentsDirectory.appendingPathComponent(imageName)
        try? fileManager.removeItem(at: imageURL)
    }
} 