import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "music.note.list")
                }
                .tag(0)
            
            CreatePostView()
                .tabItem {
                    Label("Post", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
} 