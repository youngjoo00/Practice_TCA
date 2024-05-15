//
//  Practice_TCAApp.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/16/24.
//

import SwiftUI
import ComposableArchitecture

//@main
//struct Practice_TCAApp: App {
//    var body: some Scene {
//            WindowGroup {
//                CounterView(
//                    store: Store(
//                        initialState: CounterState(),
//                        reducer: counterReducer,
//                        environment: CounterEnvironment()
//                    )
//                )
//            }
//        }
//}

@main
struct Practice_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: Feature.State()) {
                    Feature()
                }
            )
        }
    }
}
