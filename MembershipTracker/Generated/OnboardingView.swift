import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Track your memberships and subscriptions easily",
            image: "doc.text.fill",
            description: "Keep all your subscriptions organized in one place"
        ),
        OnboardingPage(
            title: "Get reminders for upcoming payments",
            image: "bell.fill",
            description: "Never miss a payment with timely notifications"
        ),
        OnboardingPage(
            title: "Stay organized and control your spending",
            image: "chart.pie.fill",
            description: "Analyze your spending patterns and save money"
        )
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Button(action: nextButtonTapped) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.bottom, 50)
        }
    }
    
    private func nextButtonTapped() {
        if currentPage == pages.count - 1 {
            hasCompletedOnboarding = true
        } else {
            withAnimation {
                currentPage += 1
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let image: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 50)
            
            Text(page.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
