//
//  CounterView.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/16/24.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    // 4. Feature 를 갖는 store 생성
    // 액션을 처리하여 상태를 업데이트하고, 효과를 실행하며, 이러한 효과로부터의 데이터를 시스템으로 다시 피드백할 수 있는 객체
    // Store는 let으로 보관할 수 있습니다. Store 안의 데이터에 대한 관찰은 ObservableState() 매크로를 사용하여 자동으로 이루어집니다.
    let store: StoreOf<CounterFeature>
    
    // Step 4에서는 동적 멤버 조회를 통해 Store로부터 상태의 속성을 직접 읽을 수 있으며, send(_:) 메서드를 통해 Store에 액션을 보낼 수 있습니다.
    var body: some View {
        VStack {
            CountText(count: store.count)
            
            HStack {
                IndrementButton(text: "+") { store.send(.incrementButtonTapped) }
                DecrementButton(text: "-") { store.send(.incrementButtonTapped) }
            }
        }
        
    }
    
    
}

#Preview {
    // 5. Store는 기능이 시작되길 원하는 초기 상태뿐만 아니라, 기능을 구동하는 리듀서를 지정하는 후행 클로저를 제공함으로써 구성할 수 있습니다.
    CounterView(
        store: Store(initialState: CounterFeature.State(), reducer: {
            // 리듀서 프로토콜을 채택한 값을 사용한다는 의미인듯
            
            // 6. 리듀서 주석을 해제함으로서 빈 깡통 스토어를 초기화해서 뷰를 확인할 수도 있음
            CounterFeature()
        })
    )
}

struct CountText: View {
    
    let count: Int
    var body: some View {
        Text("\(count)")
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
    }
}

struct IndrementButton: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(text) { action() }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}

struct DecrementButton: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(text) { action() }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}
