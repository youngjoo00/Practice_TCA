//
//  ContactsView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    
    @Perception.Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        // 버전 대응 합시다..
        WithPerceptionTracking {
            NavigationStack {
                List(store.contacts) { contact in
                    HStack {
                        Text(contact.name)
                        Spacer()
                        Button {
                            self.store.send(.deleteButtonTapped(id: contact.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
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
            // item이 non-nil 값으로 변경될 때 시트를 표시
            // .scope 메서드는 스토어의 특정 부분에 초점을 맞춘 새로운 스토어를 생성함
            .sheet(item: $store.scope(state: \.destination?.addContact, action: \.destination.addContact)) { addContactStore in
                NavigationStack {
                    /*
                     여기서 addContactStore는 위에서 .scope를 통해 생성된 스토어의 스코프 버전입니다.
                     이 스토어는 AddContactView가 필요로 하는 상태와 액션에만 접근할 수 있도록 제한됩니다.
                     이 코드의 핵심은 store.scope를 사용하여 전체 앱 상태에서 특정 기능에 필요한 부분만을 추출하여 그 기능의 뷰에 전달하는 것입니다.
                     이 방식은 코드의 재사용성과 관리의 용이성을 높여줍니다.
                     */
                    AddContactView(store: addContactStore)
                }
            } // sheet
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        }
        
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
