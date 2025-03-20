//
//  spotifyTrackData.swift
//  HitSong
//
//  Created by user on 2020/8/18.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation

// MARK: - PlaylistsData
struct PlaylistsData: Codable {
    let href: String?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    let items: [Item]?
}

struct Item: Codable {
    let collaborative: Bool?
    let description: String?        // 對應 JSON "description"
    let externalUrls: ExternalUrl?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: Owner?
    let primaryColor: String?         // 對應 JSON "primary_color"
    let publicField: Bool?            // 對應 JSON "public"
    let snapshotId: String?           // 對應 JSON "snapshot_id"
    let tracks: Track?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case collaborative
        case description
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case primaryColor = "primary_color"
        case publicField = "public"
        case snapshotId = "snapshot_id"
        case tracks, type, uri
    }
}

struct Track: Codable {
    let href: String?
    let total: Int?
}

struct Owner: Codable {
    let displayName: String?
    let externalUrls: ExternalUrl?
    let href: String?
    let id: String?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

struct Image: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

struct ExternalUrl: Codable {
    let spotify: String?
}
