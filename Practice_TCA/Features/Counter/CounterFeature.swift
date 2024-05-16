//
//  CounterFeature.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/16/24.
//

import Foundation
import ComposableArchitecture

// Reducer Protocol 채택
struct CounterFeature: Reducer {
    
    // 1. 상태 세팅
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    // 2. 액션 세팅
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
    }
    
    // 3. action 과 State 를 관리하는 Reducer 세팅
    // ReducerOf<R: Reducer> = Reducer<R.State, R.Action>
    // Reduce(<#T##reduce: (inout State, Action) -> Effect<Action>##(inout State, Action) -> Effect<Action>##(_ state: inout State, _ action: Action) -> Effect<Action>#>)
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // 단순한 계산, None Side Effect
            // 나중에 복잡한 코드있을 때 다시 봅시다.
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .factButtonTapped: // Effect, SideEffect
                /*
                 Composable Architecture는 "효과(effect)"라는 개념을 리듀서의 정의에 직접 포함시킵니다.
                 리듀서가 상태를 변형시키며 액션을 처리한 후, 'Effect'라고 불리는 것을 반환할 수 있으며, 이는 스토어에 의해 실행되는 비동기 단위를 나타냅니다.
                 효과는 외부 시스템과 소통할 수 있으며, 외부에서 데이터를 다시 리듀서로 전달할 수 있습니다.
                 */
                state.fact = nil
                state.isLoading = true
                
                // run closure
                return .run { [count = state.count] send in
                    let (data, response) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact)) // 1. 통신 결과를 다시 send -> 3.
                    // state.fact = fact
                    // 🛑 Mutable capture of 'inout' parameter 'state' is not allowed in
                    //    concurrently-executing code
                    // 네트워크에서 데이터를 가져온 후에 state.fact를 변경하는 것은 불가능합니다.
                    // 이는 컴파일러에 의해 엄격하게 강제되며, sendable 클로저는 inout 상태를 캡처할 수 없기 때문
                }
                
//                let (data, _) = try await URLSession.shared
//                    .data(from: URL(string: "http://numbersapi.com/\(state.count)")!)
                // 🛑 'async' call in a function that does not support concurrency
                // 현재 함수가 동시성을 지원하지 않는데 async 호출을 사용했다는 것을 경고합니다.
                // Swift에서는 비동기 함수를 호출하려면 해당 함수 또한 비동기로 선언되어 있거나 동시성을 지원하는 컨텍스트에서 호출되어야 합니다.
                
                // 🛑 Errors thrown from here are not handled
                // 이 주석은 try 키워드를 사용하여 에러를 던질 수 있는 호출을 하고 있지만, 이 에러를 처리하는 코드가 없다는 것을 경고합니다.
                // Swift에서는 try로 에러를 던질 수 있는 함수를 호출할 때, 이를 do-catch 블록으로 감싸거나 에러를 호출한 곳으로 전파할 수 있도록 해야 합니다.
            case .factResponse(let fact): // 2.
                state.fact = fact
                state.isLoading = false
                return .none
            }
        }
        
    }
}
