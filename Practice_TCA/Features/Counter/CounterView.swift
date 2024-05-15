//
//  CounterView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/16/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                return .none
                
            case .numberFactButtonTapped:
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared.data(
                        from: URL(string: "http://numbersapi.com/\(count)/trivia")!
                    )
                    await send(
                        .numberFactResponse(String(decoding: data, as: UTF8.self))
                    )
                }
                
            case let .numberFactResponse(fact):
                state.numberFact = fact
                return .none
            }
        }
    }
}

// 공식문서보고 작성해봤는데 이해 안되서 강의 찾아봐야할듯
struct CounterView: View {
//    let store: Store<CounterState, CounterAction>

    let store: StoreOf<Feature>

     var body: some View {
       Form {
         Section {
           Text("\(store.count)")
           Button("Decrement") { store.send(.decrementButtonTapped) }
           Button("Increment") { store.send(.incrementButtonTapped) }
         }

         Section {
           Button("Number fact") { store.send(.numberFactButtonTapped) }
         }
         
         if let fact = store.numberFact {
           Text(fact)
         }
       }
     }
}
