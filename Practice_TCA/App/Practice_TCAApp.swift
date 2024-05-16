//
//  Practice_TCAApp.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/16/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct Practice_TCAApp: App {
    
    private static let store = Store(initialState: CounterFeature2.State()) {
        CounterFeature2()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView2(store: Practice_TCAApp.store)
        }
    }
}
