//
//  AddContactFeature.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {
    
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        case delegate(Delegate)
        
        // 이 열거형은 부모가 듣고 해석할 수 있는 모든 액션을 설명합니다.
        // 이를 통해 자식 기능이 부모에게 직접 원하는 작업을 알릴 수 있습니다.
        /*
         Q. 이 작업들이 자식에서 무슨일이 일어나는지에 대한 명확한 의미는 모르게 하고, 값을 직접적으로 전달받기 위해서 하는 리팩토링 인거지?
         A. 네, 맞습니다. 이러한 리팩토링 작업의 목적은 부모 컴포넌트가 자식 컴포넌트에서 발생하는 구체적인 이벤트나 상태 변화의 세부 사항을 직접적으로 알 필요 없이, 자식 컴포넌트로부터 명확한 의도나 요청(action)을 전달받기 위함입니다.
            이를 통해 코드의 결합도를 낮추고, 각 컴포넌트의 독립성을 높여 유지보수성과 확장성을 향상시킬 수 있습니다.
            더 나아가, 이 방법은 자식 컴포넌트가 어떤 행위를 해야 할 때, 그 행위의 구체적인 실행 방법이 아닌 '무엇을 해야 하는지'에 대한 의도만을 부모 컴포넌트에 전달하게 합니다.
            이렇게 함으로써, 자식 컴포넌트의 내부 로직이 변경되더라도 부모 컴포넌트에 영향을 주지 않고, 또한 부모 컴포넌트는 자식 컴포넌트의 세부 구현 사항에 의존하지 않게 됩니다.
            결국, 이는 시스템 전체의 유연성과 코드 재사용성을 증진시키는 효과를 가져옵니다.
         */
        enum Delegate: Equatable {
            // 자식을 해제해야 한다는 것을 부모에게 명시적으로 알릴 필요가 없습니다. 그 모든 것은 DismissEffect에 의해 처리됩니다.
            // case cancel
            case saveContact(Contact)
        }
    }

    // DependencyValues 내의 dismiss 속성 값을 @Dependency 프로퍼티 래퍼를 통해 주입받고 있음을 나타냅니다.
    // 의존성 주입이란, 객체가 필요로 하는 다른 객체(의존성)를 외부에서 제공해주는 디자인 패턴 중 하나입니다.
    @Dependency(\.dismiss)
    var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                // return 으로 send 가능헀네?
                // return .send(.delegate(.cancel))
                /*
                 구조체의 경우는 값 타입이기 때문에 이러한 문제가 발생하지 않습니다. 클로저 내에서 구조체의 self를 사용하더라도, 구조체는 복사되어 전달되므로 참조 사이클이 생길 여지가 없습니다.
                 따라서, 구조체를 사용할 때는 ARC에 대해 고민할 필요가 없으며, 클로저 내에서 self를 사용하는 것에 대해서도 특별히 걱정할 필요가 없습니다.
                 */
                return .run { _ in await self.dismiss() }
            case .saveButtonTapped:
                // 자식에서 갖고있는 state.contact 값을 들고 보내주자
                // return .send(.delegate(.saveContact(state.contact)))
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case .setName(let name):
                state.contact.name = name
                print(state.contact.name)
                return .none
            case .delegate: // 이 경우에는 실제로 어떤 로직도 수행해서는 안 됩니다. 오직 부모만이 대리(delegate) 액션을 듣고 그에 따라 반응해야 합니다.
                return .none
            }
        }
    }
}
