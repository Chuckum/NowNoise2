import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            
            await MainActor.run {
                isAuthorized = granted
                if granted {
                    scheduleDailyNotification()
                }
            }
        } catch {
            print("Error requesting notification authorization: \(error.localizedDescription)")
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Share Your Music"
        content.body = "What are you listening to right now?"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 8 PM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
} 