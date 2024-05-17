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
    
    private static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    private static let appFeatureStore = Store(initialState: TabFeature.State()) {
        TabFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            //CounterView(store: Practice_TCAApp.store)
            MainTabView(store: Practice_TCAApp.appFeatureStore)
        }
    }
}
