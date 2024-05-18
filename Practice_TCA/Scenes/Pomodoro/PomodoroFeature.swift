//
//  PomodoroFeature.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PomodoroFeature {
    
    struct State: Equatable {
        var isTimerActive = false
    }
    
    enum Action {
        case startTapped
        case stopTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTapped:
                state.isTimerActive = true
                return .none
            case .stopTapped:
                state.isTimerActive = false
                return .none
            }
        }
    }
}
