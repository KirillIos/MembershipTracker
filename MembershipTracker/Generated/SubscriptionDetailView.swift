import SwiftUI

struct SubscriptionDetailView: View {
    let subscription: Subscription
    @ObservedObject var store: SubscriptionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var amount: Double
    @State private var nextPaymentDate: Date
    @State private var frequency: Subscription.PaymentFrequency
    @State private var category: Subscription.SubscriptionCategory
    @State private var notes: String
    @State private var isActive: Bool
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    
    init(subscription: Subscription, store: SubscriptionStore) {
        self.subscription = subscription
        self.store = store
        _name = State(initialValue: subscription.name)
        _amount = State(initialValue: subscription.amount)
        _nextPaymentDate = State(initialValue: subscription.nextPaymentDate)
        _frequency = State(initialValue: subscription.frequency)
        _category = State(initialValue: subscription.category)
        _notes = State(initialValue: subscription.notes)
        _isActive = State(initialValue: subscription.isActive)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscription Details")) {
                    if isEditing {
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
                        Toggle("Active", isOn: $isActive)
                    } else {
                        DetailRow(title: "Name", value: name)
                        DetailRow(title: "Amount", value: "$\(String(format: "%.2f", amount))")
                        DetailRow(title: "Next Payment", value: nextPaymentDate.formatted(date: .long, time: .omitted))
                        DetailRow(title: "Frequency", value: frequency.rawValue)
                        DetailRow(title: "Category", value: category.rawValue)
                        DetailRow(title: "Status", value: isActive ? "Active" : "Inactive")
                    }
                }
                
                Section(header: Text("Notes")) {
                    if isEditing {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    } else {
                        Text(notes)
                    }
                }
                
                if !isEditing {
                    Section {
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Text("Delete Subscription")
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Subscription" : "Subscription Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveChanges()
                        }
                        isEditing.toggle()
                    }
                }
                if isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isEditing = false
                            resetFields()
                        }
                    }
                }
            }
            .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteSubscription()
                }
            } message: {
                Text("Are you sure you want to delete this subscription?")
            }
        }
    }
    
    private func saveChanges() {
        let updatedSubscription = Subscription(
            id: subscription.id,
            name: name,
            amount: amount,
            nextPaymentDate: nextPaymentDate,
            frequency: frequency,
            category: category,
            notes: notes,
            isActive: isActive
        )
        store.updateSubscription(updatedSubscription)
    }
    
    private func deleteSubscription() {
        store.deleteSubscription(subscription)
        dismiss()
    }
    
    private func resetFields() {
        name = subscription.name
        amount = subscription.amount
        nextPaymentDate = subscription.nextPaymentDate
        frequency = subscription.frequency
        category = subscription.category
        notes = subscription.notes
        isActive = subscription.isActive
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}

#Preview {
    SubscriptionDetailView(
        subscription: Subscription(
            name: "Netflix",
            amount: 15.99,
            nextPaymentDate: Date(),
            frequency: .monthly,
            category: .entertainment,
            notes: "Family plan"
        ),
        store: SubscriptionStore()
    )
}
