import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(subscription.name)
                    .font(.headline)
                Spacer()
                Text(subscription.category.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(categoryColor)
                    .cornerRadius(4)
            }
            
            HStack {
                Text(subscription.amount, format: .currency(code: "USD"))
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("/ \(subscription.frequency.rawValue.lowercased())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text("Next payment: \(subscription.nextPaymentDate.formatted(date: .long, time: .omitted))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    var categoryColor: Color {
        switch subscription.category {
        case .entertainment: return .purple.opacity(0.2)
        case .sports: return .green.opacity(0.2)
        case .professional: return .blue.opacity(0.2)
        case .other: return .gray.opacity(0.2)
        }
    }
}
