//
//  PomodoroView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/18/24.
//

import SwiftUI
import ComposableArchitecture

struct PomodoroView: View {
    
    let store: StoreOf<PomodoroFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    
                }
            }
        }
    }
}

#Preview {
    PomodoroView(
        store: Store(
            initialState: PomodoroFeature.State()) {
                PomodoroFeature()
        }
    )
}
