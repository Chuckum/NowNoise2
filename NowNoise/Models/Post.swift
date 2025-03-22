import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let songName: String
    let timestamp: Date
    let imageURL: String?
    let genre: String?
    
    init(songName: String, timestamp: Date, imageURL: String? = nil, genre: String? = nil) {
        self.id = UUID().uuidString
        self.songName = songName
        self.timestamp = timestamp
        self.imageURL = imageURL
        self.genre = genre
    }
} 