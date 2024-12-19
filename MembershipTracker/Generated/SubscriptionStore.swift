import Foundation

struct Subscription: Identifiable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
    var nextPaymentDate: Date
    var frequency: PaymentFrequency
    var category: SubscriptionCategory
    var notes: String
    var isActive: Bool = true
    
    enum PaymentFrequency: String, Codable, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        case weekly = "Weekly"
    }
    
    enum SubscriptionCategory: String, Codable, CaseIterable {
        case entertainment = "Entertainment"
        case sports = "Sports"
        case professional = "Professional"
        case other = "Other"
    }
}

class SubscriptionStore: ObservableObject {
    @Published var subscriptions: [Subscription] = []
    
    private let saveKey = "Subscriptions"
    
    init() {
        loadSubscriptions()
    }
    
    func addSubscription(_ subscription: Subscription) {
        subscriptions.append(subscription)
        saveSubscriptions()
    }
    
    func deleteSubscription(_ subscription: Subscription) {
        if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
            subscriptions.remove(at: index)
            saveSubscriptions()
        }
    }
    
    func updateSubscription(_ subscription: Subscription) {
        if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
            subscriptions[index] = subscription
            saveSubscriptions()
        }
    }
    
    private func saveSubscriptions() {
        if let encoded = try? JSONEncoder().encode(subscriptions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadSubscriptions() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Subscription].self, from: data) {
                subscriptions = decoded
            }
        }
    }
}