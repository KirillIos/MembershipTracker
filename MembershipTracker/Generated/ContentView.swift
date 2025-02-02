import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var store = SubscriptionStore()
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainTabView(store: store)
            }
        }
    }
}

struct MainTabView: View {
    @StateObject var store: SubscriptionStore
    @State private var selectedTab = 0
    
    init(store: SubscriptionStore) {
        _store = StateObject(wrappedValue: store)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                SubscriptionListView(store: store)
            }
            .tabItem {
                Label("Subscriptions", systemImage: "list.bullet")
            }
            .tag(0)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(1)
        }
    }
}

