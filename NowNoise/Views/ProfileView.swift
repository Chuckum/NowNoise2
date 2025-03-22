import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        Text("All").tag(Filter.all)
                        Text("Today").tag(Filter.today)
                        Text("Week").tag(Filter.week)
                        Text("Month").tag(Filter.month)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    ForEach(viewModel.filteredPosts) { post in
                        PostRowView(post: post)
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.loadPosts()
            }
        }
    }
}

struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.songName)
                .font(.headline)
            
            if let genre = post.genre {
                Text(genre)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(post.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

enum Filter: String, CaseIterable {
    case all, today, week, month
}

class ProfileViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var selectedFilter: Filter = .all
    
    var filteredPosts: [Post] {
        switch selectedFilter {
        case .all:
            return posts
        case .today:
            return posts.filter { Calendar.current.isDateInToday($0.timestamp) }
        case .week:
            return posts.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .weekOfYear) }
        case .month:
            return posts.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .month) }
        }
    }
    
    func loadPosts() {
        posts = StorageManager.shared.loadPosts()
    }
} 