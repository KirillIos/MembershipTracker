import SwiftUI

struct SubscriptionListView: View {
    @ObservedObject var store: SubscriptionStore
    @State private var selectedCategory: Subscription.SubscriptionCategory?
    @State private var showActiveOnly = true
    @State private var selectedSubscription: Subscription?
    @State private var showingAddSubscription = false
    
    init(store: SubscriptionStore) {
        self.store = store
    }
    
    var filteredSubscriptions: [Subscription] {
        store.subscriptions.filter { subscription in
            let categoryMatch = selectedCategory == nil || subscription.category == selectedCategory
            let activeMatch = !showActiveOnly || subscription.isActive
            return categoryMatch && activeMatch
        }
    }
    
    var body: some View {
        VStack {
            filterHeader
            
            List {
                ForEach(filteredSubscriptions) { subscription in
                    SubscriptionCard(subscription: subscription)
                        .onTapGesture {
                            selectedSubscription = subscription
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                store.deleteSubscription(subscription)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("Memberships")
        .sheet(item: $selectedSubscription) { subscription in
            SubscriptionDetailView(subscription: subscription, store: store)
        }
        .sheet(isPresented: $showingAddSubscription) {
            AddSubscriptionView(store: store, isPresented: $showingAddSubscription)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddSubscription = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    var filterHeader: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FilterButton(title: "All", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    
                    ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                        FilterButton(title: category.rawValue, isSelected: selectedCategory == category) {
                            selectedCategory = category
                        }
                    }
                }
                .padding()
            }
            
            Toggle("Show Active Only", isOn: $showActiveOnly)
                .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        SubscriptionListView(store: SubscriptionStore())
    }
}
