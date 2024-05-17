//
//  AppFeature.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TabFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        // Scope를 사용하여 AppFeature의 상태와 액션을 각 탭의 리듀서로 매핑합니다.
        // 각각 초기화해서 따로 쓸 수 있음!
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}
