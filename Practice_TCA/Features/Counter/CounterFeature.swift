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
    }
    
    // 2. 액션 세팅
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
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
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            }
        }
        
    }
}
