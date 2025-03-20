//
//  SearchData.swift
//  MusicPlayer
//
//  Created by Duncan Li on 2025/3/20.
//  Copyright © 2025 abc. All rights reserved.
//
import Foundation
// MARK: - SearchData
struct SearchData: Codable {
    let tracks: SearchTrack
}

struct SearchTrack: Codable {
    let href: String
    let limit: Int
    let next: String
    let total: Int
    let items: [SearchItem]?
}

struct SearchItem: Codable {
    let album: SearchAlbum?
    let artists: [SearchArtist]?
    let href: String?
    let id: String?
    let isLocal: Bool?
    let name: String?
    let popularity: Int?
    let previewUrl: String?
    let trackNumber: Int?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case album, artists, href, id
        case isLocal = "is_local"
        case name, popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

struct SearchAlbum: Codable {
    let href: String?
    let id: String?
    let images: [SearchImage]?
    let name: String?
    let releaseDate: String?
    let releaseDatePrecision: String?
}

struct SearchImage: Codable {
    let url: String?
}

struct SearchArtist: Codable {
    let href: String?
    let id: String?
    let name: String?
    let type: String?
    let uri: String?
}
