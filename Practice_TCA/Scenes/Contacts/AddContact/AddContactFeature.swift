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
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .none
            case .saveButtonTapped:
                return .none
            case .setName(let name):
                state.contact.name = name
                print(state.contact.name)
                return .none
            }
        }
    }
}
