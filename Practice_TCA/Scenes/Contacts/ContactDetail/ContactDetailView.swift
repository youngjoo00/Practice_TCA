//
//  ContactDetailView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/18/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    
    @Perception.Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        WithPerceptionTracking {
            Form {
                Button("Delete") {
                    store.send(.deleteButtonTapped)
                }
            }
            .navigationTitle(store.contact.name)
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(
            store: Store(
                initialState: ContactDetailFeature.State(
                    contact: Contact(name: "youngjoo"))
            ) {
                ContactDetailFeature()
            }
        )
    }
}
