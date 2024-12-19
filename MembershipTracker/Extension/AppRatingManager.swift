import StoreKit
import SwiftUI

final class AppRatingManager: ObservableObject {
    static let shared = AppRatingManager()
    @AppStorage("APP_LAUNCH_COUNT") private var appLaunchCount = 0
    @AppStorage("LAST_RATING_REQUEST") private var lastRatingRequest = Date.distantPast.timeIntervalSince1970
    @AppStorage("RATING_REQUEST_COUNT") private var ratingRequestCount = 0
    
    private let minLaunchesBeforeRating = 0
    private let minDaysBetweenRequests = 1.0
    private let maxRatingRequests = 5
    
    private init() {}
    
    func incrementLaunchCount() {
        appLaunchCount += 1
    }
    
    func shouldRequestRating() -> Bool {
        let daysSinceLastRequest = Date().timeIntervalSince1970 - lastRatingRequest
        return appLaunchCount >= minLaunchesBeforeRating &&
               (daysSinceLastRequest / 86400) >= minDaysBetweenRequests &&
               ratingRequestCount < maxRatingRequests
    }

    func requestRating() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        
        SKStoreReviewController.requestReview(in: scene)
        lastRatingRequest = Date().timeIntervalSince1970
        ratingRequestCount += 1
    }

    func checkAndRequestReview() {
        guard shouldRequestRating() else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.requestRating()
        }
    }
    
}
