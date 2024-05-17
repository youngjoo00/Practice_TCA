//
//  AddContactView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    
    @Perception.Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            // state 에 접근해서 action sending
            // func sending(_ action: CaseKeyPath<AddContactFeature.Action, String>) -> Binding<String>
            TextField("Name", text: $store.contact.name.sending(\.setName))
            
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: Store(
                initialState: AddContactFeature.State(
                    contact: Contact(
                        name: "Blob"
                    )
                )
            ) {
                AddContactFeature()
            }
        )
    }
}
