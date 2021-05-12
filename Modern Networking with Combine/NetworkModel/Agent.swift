//
//  Agent.swift
//  Modern Networking with Combine
//
//  Created by klioop on 2021/05/12.
//

import Foundation
import Combine

struct Agent{
    
    // 1
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    // 2
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request) // 3
            .mapError{ error in
                // network error
                error // one line result enable to exclude return keyword
            }
            .tryMap{ result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data) // 4
                return Response(value: value, response: result.response) // 5
            }
            .mapError{ error in
                    // transform error here
              return error
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

