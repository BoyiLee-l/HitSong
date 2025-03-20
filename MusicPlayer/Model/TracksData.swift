//
//  Untitled.swift
//  MusicPlayer
//
//  Created by Duncan Li on 2025/3/20.
//  Copyright © 2025 abc. All rights reserved.
//

import Foundation
// MARK: - TracksData
struct TracksData: Codable {
    let href: String?
    let items: [PlaylistTrackItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

struct PlaylistTrackItem: Codable {
    let addedAt: String?
    let isLocal: Bool?
    let primaryColor: String?
    let track: Track2?
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case isLocal = "is_local"
        case primaryColor = "primary_color"
        case track
    }
}

struct Track2: Codable {
    let album: Album?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let discNumber: Int?
    let durationMs: Int?
    let episode: Bool?
    let explicit: Bool?
    // 若有 externalIds 也可在此加入
    let externalUrls: ExternalUrl2?
    let href: String?
    let id: String?
    let isLocal: Bool?
    let name: String?
    let popularity: Int?
    let previewUrl: String?
    let track: Bool?
    let trackNumber: Int?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case episode, explicit
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewUrl = "preview_url"
        case track
        case trackNumber = "track_number"
        case type, uri
    }
}

struct Artist: Codable {
    let externalUrls: ExternalUrl2?
    let href: String?
    let id: String?
    let name: String?
    let type: String?
    let uri: String?
}

struct ExternalUrl2: Codable {
    let spotify: String?
}

struct Album: Codable {
    let albumType: String?
    let artists: [Artist]?
    let externalUrls: ExternalUrl2?
    let href: String?
    let id: String?
    let images: [Image2]?
    let name: String?
    let releaseDate: String?
    let releaseDatePrecision: String?
    let totalTracks: Int?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

struct Image2: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}
