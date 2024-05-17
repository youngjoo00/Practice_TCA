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
    }
    
    enum Action {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                return .none
            }
        }
    }
}
