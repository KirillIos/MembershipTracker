import SwiftUI

struct AddSubscriptionView: View {
    @ObservedObject var store: SubscriptionStore
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var amount = 0.0
    @State private var nextPaymentDate = Date()
    @State private var frequency = Subscription.PaymentFrequency.monthly
    @State private var category = Subscription.SubscriptionCategory.entertainment
    @State private var notes = ""
    @State private var showingSuccessToast = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscription Details")) {
                    TextField("Name", text: $name)
                    
                    HStack {
                        Text("$")
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Next Payment", selection: $nextPaymentDate, displayedComponents: .date)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(Subscription.PaymentFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: saveSubscription) {
                        Text("Save Subscription")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .overlay(
                ToastView(isShowing: $showingSuccessToast)
            )
        }
    }
    
    private func saveSubscription() {
        let subscription = Subscription(
            name: name,
            amount: amount,
            nextPaymentDate: nextPaymentDate,
            frequency: frequency,
            category: category,
            notes: notes
        )
        
        store.addSubscription(subscription)
        showingSuccessToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPresented = false
        }
    }
}

struct ToastView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Subscription Added Successfully")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}
