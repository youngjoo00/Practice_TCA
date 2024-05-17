//
//  AppView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/17/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
//    let store1: StoreOf<CounterFeature>
//    let store2: StoreOf<CounterFeature>
    let store: StoreOf<TabFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }
            
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
            
            // 왜 얘들도 scope 에 접근해서 공유해서 쓸 수 있을까??
            CounterView(store: store.scope(state: \.tab1, action: \.tab2))
                .tabItem {
                    Text("Counter 3")
                }
            
            CounterView(store: store.scope(state: \.tab2, action: \.tab1))
                .tabItem {
                    Text("Counter 4")
                }
        }
    }
}

#Preview {
    MainTabView(
        store: Store(initialState: TabFeature.State()) {
            TabFeature()
        }
    )
}
        
