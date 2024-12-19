import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: rateApp) {
                        Label("Rate this App", systemImage: "star.fill")
                    }
                    
                    Button(action: shareApp) {
                        Label("Share this App", systemImage: "square.and.arrow.up")
                    }
                }
                
                Section(header: Text("Legal")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        Text("Terms of Use")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func rateApp() {
        requestReview()
    }
    
    private func shareApp() {
        let url = URL(string: "https://apps.apple.com/app/id123456789")!
        let activityController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityController, animated: true)
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("Privacy Policy\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            Text("Terms of Use\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .padding()
        }
        .navigationTitle("Terms of Use")
    }
}
