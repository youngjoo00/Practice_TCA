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
        var contacts: IdentifiedArrayOf<Contact> = []
        /*
         속성 감시: @Presents는 PresentationState를 사용하여 속성을 감싸고 관찰합니다. 이를 통해 해당 속성의 변화를 감지하고 UI를 적절히 업데이트할 수 있게 됩니다.
         상태 표시 관리: @Presents를 사용하면 특정 기능의 상태가 nil인지 아닌지에 따라 그 기능이 사용자에게 표시되는지 여부를 관리할 수 있습니다.
         예를 들어, 어떤 기능의 상태가 nil이면 해당 기능이 화면에 표시되지 않으며, nil이 아닌 값으로 설정되면 화면에 표시됩니다.
         */
        //        @Presents var addContact: AddContactFeature.State?
        //        @Presents var alert: AlertState<Action.Alert>?
        @Presents var destination: Destination.State? // Presents 병합
    }
    
    enum Action {
        case addButtonTapped
        //case addContact(PresentationAction<AddContactFeature.Action>) // 자식 기능에서 발생하는 모든 액션들을 부모 기능에서 감지하고 반응
        case deleteButtonTapped(id: Contact.ID)
        //case alert(PresentationAction<Alert>) // 알림에서의 선택은 삭제를 취소하거나 확인하는 것뿐이지만, 취소 액션을 모델링할 필요는 없습니다. 이는 자동으로 처리될 것입니다.
        case destination(PresentationAction<Destination.Action>) // Destination.Action 을 유지하는 단일 케이스로 대체
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                //state.addContact = AddContactFeature.State(contact: Contact(name: ""))
                state.destination = .addContact( // destination 을 addContact 케이스를 가리키도록 변경(mutate)
                    AddContactFeature.State(
                        contact: Contact(name: "")
                    )
                )
                return .none
                
                //            case .addContact(.presented(.delegate(.cancel))): // 1. 자식에 있는 delegate.cancel 감지, 2. 이제 필요 없음
                //                state.addContact = nil
                //                return .none
                
                //            case .addContact(.presented(.delegate(.saveContact(let contact)))):
                //                // 상태가 값을 갖고 있으니 contact 값을 언래핑해서 가져옴
                //                // guard let contact = state.addContact?.contact else { return .none }
                //                state.contacts.append(contact)
                ////                state.addContact = nil
                //                return .none
                
                //            case .addContact:
                //                return .none
                
                // 자식 도메인에서 발생하는 액션을 수신할 때, 예를 들어 "연락처 추가" 기능이 연락처 저장을 요청할 때, .destination(.presented(_)) 케이스를 분해
            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
                
                // 연락처 삭제를 확인하는 경고창이 나타날 때입니다.
            case .destination(.presented(.alert(.confirmDeletion(id: let id)))):
                state.contacts.remove(id: id)
                return .none
                
            case .destination:
                return .none
                
            case .deleteButtonTapped(let id):
                //                state.alert = AlertState {
                //                    TextState("Are you sure?")
                //                } actions: {
                //                    // role 에 cancel 도 있음, 근데 알아서 cancelButton 만들어줌
                //                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                //                        TextState("Delete")
                //                    }
                //                }
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
                
                //            case .alert(.presented(.confirmDeletion(id: let id))):
                //                state.contacts.remove(id: id)
                //                return .none
                //
                //            case .alert:
                //                return .none
                //            }
            }
        }
        // _: state 의 옵셔널 프로퍼티 addContact 를 의미
        // action: 부모 액션(Action) 중에서 자식 액션을 처리하기 위한 케이스를 지정합니다.
        // 즉, 부모 액션 내에 정의된 child 케이스가 자식 액션을 포함하고 있을 때, 이를 인식하고 자식 리듀서를 실행하라는 의미입니다.
        //        .ifLet(\.$addContact, action: \.addContact) {
        //            AddContactFeature() // 자식 리듀서를 생성하고 실행
        //        }
        //        .ifLet(\.$alert, action: \.alert)
        /*
         두 개의 ifLet을 목적지 도메인에 초점을 맞춘 단 하나의 ifLet으로 대체합니다.
         이 표현식에서 Destination 타입을 명시할 필요조차 없습니다.
         왜냐하면 Reducer() 매크로가 Destination 열거형에 적용되는 방식으로부터 타입이 추론될 수 있기 때문입니다.
         
         이것만으로도 독립적이며 정확하게 모델링되지 않은 두 개의 선택적 값들을 단일 선택적 열거형으로 변환할 수 있으며, 이제 한 번에 하나의 목적지만 활성화될 수 있음을 증명할 수 있습니다.
         남은 것은 목적지 열거형의 어떤 케이스가 시트와 경고를 구동하는지 지정할 수 있도록 뷰를 업데이트하는 것뿐입니다.
         */
        .ifLet(\.$destination, action: \.destination)
    }
}

// 이동할 수 있는 모든 기능의 도메인과 로직을 담는 리듀서 확장
extension ContactsFeature {
    
    // 매크로의 state 매개변수에 codable, equatable 등 다양한 프로토콜 채택이 가능하네
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature) // 상태가 아닌 실제 'AddContactFeature' 리듀서를 케이스에 보관
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}
