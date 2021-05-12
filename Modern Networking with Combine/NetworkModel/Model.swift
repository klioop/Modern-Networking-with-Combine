//
//  Model.swift
//  Modern Networking with Combine
//
//  Created by klioop on 2021/05/12.
//

import Foundation

// Model
struct User: Codable {
    let id: Int
}

struct Repository: Codable {
    let id: Int
    let name: String
    let description: String?
}

struct Issue: Codable {
    let id: Int
}
