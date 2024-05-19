//
//  NumberFactClient.swift
//  Practice_TCA
//
//  Created by youngjoo on 5/19/24.
//

import ComposableArchitecture
import Foundation

// 의존성 등록
// NumberFactClient는 숫자에 대한 정보를 가져오는 클라이언트로, fetch라는 비동기 함수를 가지고 있습니다.
struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

// DependencyKey 프로토콜을 준수하도록 하여 liveValue를 제공
// NumberFactClient를 TCA의 DependencyKey로 설정하여 의존성 주입이 가능하도록 합니다.
extension NumberFactClient: DependencyKey {

    // fetch 프로퍼티를 사용
    // liveValue는 실제로 데이터를 가져오는 방법을 정의합니다.
    // 여기서는 numbersapi.com에서 숫자에 대한 정보를 가져오는 로직을 작성합니다.
    static let liveValue = Self { number in
        // URLSession을 사용하여 숫자에 대한 데이터를 가져옵니다.
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!)
        // 가져온 데이터를 문자열로 변환하여 반환합니다.
        return String(decoding: data, as: UTF8.self)
    }
}

// DependencyValues 확장을 통해 numberFact라는 새로운 프로퍼티를 생성
extension DependencyValues {
    // Dependency 매크로에서 사용할 수 있는 numberFact 프로퍼티를 생성합니다.
    // 이 프로퍼티를 통해 의존성을 주입받을 수 있습니다.
    // @Dependency(\.numberFact) 구문을 사용하여 이 의존성에 접근할 수 있게 됩니다.
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
