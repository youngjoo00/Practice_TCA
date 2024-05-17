//
//  ContactsView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List(store.contacts) { contact in
                Text(contact.name)
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } // NavigationStack
        
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(name: "Blob"),
                    Contact(name: "Blob Jr"),
                    Contact(name: "Blob Sr"),
                ]
            )
        ) { // reducer trailing closure
            ContactsFeature()
        }
    )
}
