//
//  GithubAPI.swift
//  Modern Networking with Combine
//
//  Created by klioop on 2021/05/12.
//

import Foundation
import Combine

// namespace
enum GithubAPI {
    static let agent = Agent()
    static let base = URL(string: "https://api.github.com")!
}

extension GithubAPI {
    
    
//    static func repos(userName: String) -> AnyPublisher<[Repository], Error> {
//        // 1
//        let request = URLRequest(url: base.appendingPathComponent("users/\(userName)/repos"))
//
//        // 2
//        return agent.run(request)
//            .map(\.value)
//            .eraseToAnyPublisher()
//    }
    
//    static func issues(repo: String, owner: String) -> AnyPublisher<[Issue], Error> {
//        let request = URLRequest(url: base.appendingPathComponent("repos/\(owner)/\(repo)"))
//
//        return agent.run(request)
//            .map(\.value)
//            .eraseToAnyPublisher()
//    }
    
    // Refactoring
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func repos(userName: String) -> AnyPublisher<[Repository], Error> {
        return run(URLRequest(url: base.appendingPathComponent("users/\(userName)/repos")))
    }
    
    static func issues(repo: String, owner: String) -> AnyPublisher<[Issue], Error> {
        return run(URLRequest(url: base.appendingPathComponent("repos/\(owner)/\(repo)")))
    }
    
    static func reposOrg(org: String) -> AnyPublisher<[Repository], Error> {
        return run(URLRequest(url: base.appendingPathComponent("orgs/\(org)/repos")))
    }
    
    static func members(org: String) -> AnyPublisher<[User], Error> {
        return run(URLRequest(url: base.appendingPathComponent("orgs/\(org)/members")))
    }
}



// repos
let token = GithubAPI.repos(userName: "V8tr")
    .print()
    .sink(receiveCompletion: { _ in
        
    }, receiveValue: {
        print($0)
    })

// repos and issues: executes request one by one
let me = "V8tr"

let repos = GithubAPI.repos(userName: me)
let firstRepo = repos
    .compactMap{ $0.first }
let issues = firstRepo
    .flatMap{ repo -> AnyPublisher<[Issue], Error> in
        GithubAPI.issues(repo: repo.name, owner: me)
    }


// parallel request
let members = GithubAPI.members(org: "apple")
let reposOrg = GithubAPI.reposOrg(org: "apple")
let token3 = Publishers.Zip(members, reposOrg)
    .sink(receiveCompletion: { _ in }, receiveValue: { (members, repos) in
        print(members, repos)
    })
