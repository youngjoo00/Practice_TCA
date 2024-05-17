//
//  ContactsFeature.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import Foundation
import ComposableArchitecture


struct Contact: Equatable, Identifiable {
    let id = UUID()
    var name: String
}

@Reducer
struct ContactsFeature {

    @ObservableState
    struct State: Equatable {
        /*
         속성 감시: @Presents는 PresentationState를 사용하여 속성을 감싸고 관찰합니다. 이를 통해 해당 속성의 변화를 감지하고 UI를 적절히 업데이트할 수 있게 됩니다.
         상태 표시 관리: @Presents를 사용하면 특정 기능의 상태가 nil인지 아닌지에 따라 그 기능이 사용자에게 표시되는지 여부를 관리할 수 있습니다.
                      예를 들어, 어떤 기능의 상태가 nil이면 해당 기능이 화면에 표시되지 않으며, nil이 아닌 값으로 설정되면 화면에 표시됩니다.
         */
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>) // 자식 기능에서 발생하는 모든 액션들을 부모 기능에서 감지하고 반응
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(contact: Contact(name: ""))
                return .none
            case .addContact(.presented(.cancelButtonTapped)): // 자식에 있는 cancelButtonTapped 감지
                state.addContact = nil
                return .none
            case .addContact(.presented(.saveButtonTapped)):
                // 상태가 값을 갖고 있으니 contact 값을 언래핑해서 가져옴
                guard let contact = state.addContact?.contact else { return .none }
                state.contacts.append(contact)
                state.addContact = nil
                return .none
            case .addContact:
                return .none
            }
        }
        // _: state 의 옵셔널 프로퍼티 addContact 를 의미
        // action: 부모 액션(Action) 중에서 자식 액션을 처리하기 위한 케이스를 지정합니다.
        // 즉, 부모 액션 내에 정의된 child 케이스가 자식 액션을 포함하고 있을 때, 이를 인식하고 자식 리듀서를 실행하라는 의미입니다.
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature() // 자식 리듀서를 생성하고 실행
        }
    }
}
