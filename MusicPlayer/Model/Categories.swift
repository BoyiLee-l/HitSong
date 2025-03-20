//
//  Categories.swift
//  MusicPlayer
//
//  Created by Duncan Li on 2025/3/20.
//  Copyright © 2025 abc. All rights reserved.
//
import Foundation
// MARK: - Categories
struct Categories: Codable {
    let categories: Category?
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
}

struct Category: Codable {
    let href: String
    let items: [CategoriesItem]
    let limit: Int
    let total: Int
}

struct CategoriesItem: Codable {
    let href: String
    let icons: [Icon]
    let id: String
    let name: String
}

struct Icon: Codable {
    let url: String
}
