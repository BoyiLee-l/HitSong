//
//  spotifyTrackData.swift
//  HitSong
//
//  Created by user on 2020/8/18.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation

var keyWord: String = ""
var baseURL = "https://api.spotify.com/v1/browse/featured-playlists?country=tw&limit=20"
var categoriesURL = "https://api.spotify.com/v1/browse/categories?offset=0&limit=50"

//MARK: -PlaylistsData
struct PlaylistsData : Codable {
    let message : String?
    let playlists : Playlist?
}
struct Playlist : Codable {
    let href : String?
    let items : [Item]?
    let limit : Int?
    let next : String?
    let offset : Int?
    let previous : String?
    let total : Int?
}

struct Item : Codable {
    let collaborative : Bool?
    let descriptionField : String?
    let externalUrls : ExternalUrl?
    let href : String?
    let id : String?
    let images : [Image]?
    let name : String?
    let owner : Owner?
    let primaryColor : String?
    let publicField : String?
    let snapshotId : String?
    let tracks : Track?
    let type : String?
    let uri : String?
}

struct Track : Codable {
    let href : String?
    let total : Int?
}

struct Owner : Codable {
    let displayName : String?
    let externalUrls : ExternalUrl?
    let href : String?
    let id : String?
    let type : String?
    let uri : String?
}

struct Image : Codable {
    let height : String?
    let url : String?
    let width : String?
}

struct ExternalUrl : Codable {
    let spotify : String?
}

//MARK: -TracksData
struct TracksData : Codable {
    let href : String?
    let items : [Item2]?
    let limit : Int?
    let next : String?
    let offset : Int?
    let previous : String?
    let total : Int?
}

struct Item2 : Codable {
    let addedAt : String?
    let isLocal : Bool?
    let primaryColor : String?
    let track : Track2?
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case isLocal = "is_local"
        case primaryColor = "primary_color"
        case track
    }
    
}

struct Track2 : Codable {
    let album : Album?
    let artists : [Artist]?
    let availableMarkets : [String]?
    let discNumber : Int?
    let durationMs : Int?
    let episode : Bool?
    let explicit : Bool?
    //let externalIds : ExternalId?
    let externalUrls : ExternalUrl2?
    let href : String?
    let id : String?
    let isLocal : Bool?
    let name : String?
    let popularity : Int?
    let previewUrl : String?
    let track : Bool?
    let trackNumber : Int?
    let type : String?
    let uri : String?
    
    enum CodingKeys: String, CodingKey {
        case album
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case episode = "episode"
        case explicit = "explicit"
        // case externalIds
        case externalUrls
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewUrl = "preview_url"
        case track = "track"
        case trackNumber = "track_number"
        case type = "type"
        case uri = "uri"
    }
}

struct Artist : Codable {
    
    let externalUrls : ExternalUrl2?
    let href : String?
    let id : String?
    let name : String?
    let type : String?
    let uri : String?
    
}

struct ExternalUrl2 : Codable {
    let spotify : String?
}

struct Album : Codable {
    
    let albumType : String?
    let artists : [Artist]?
    let externalUrls : ExternalUrl2?
    let href : String?
    let id : String?
    let images : [Image2]?
    let name : String?
    let releaseDate : String?
    let releaseDatePrecision : String?
    let totalTracks : Int?
    let type : String?
    let uri : String?
    
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists = "artists"
        case externalUrls
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type = "type"
        case uri = "uri"
    }
}
struct Image2 : Codable {
    let height : Int?
    let url : String?
    let width : Int?
}

//MARK: -Categories

struct Categories : Codable {
    let categories : Category?
    
    enum CodingKeys: String, CodingKey {
        case categories
    }
}

struct Category : Codable {
    let href : String
    let items : [CategoriesItem]
    let limit : Int
    let total : Int
}

struct CategoriesItem : Codable {
    
    let href : String
    let icons : [Icon]
    let id : String
    let name : String
}

struct Icon : Codable {
    let url : String
}

//MARK: -SearchData

struct SearchData : Codable {
    let tracks : SearchTrack
}

struct SearchTrack : Codable {
    let href : String
    let limit : Int
    let next : String
    let total : Int
    let items : [SearchItem]?
}
struct SearchItem : Codable {
    let album : SearchAlbum?
    let artists : [SearchArtist]?
    let href : String?
    let id : String?
    let isLocal : Bool?
    let name : String?
    let popularity : Int?
    let previewUrl : String?
    let trackNumber : Int?
    let type : String?
    let uri : String?
    enum CodingKeys: String, CodingKey {
        case album
        case artists = "artists"
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type = "type"
        case uri = "uri"
    }
}

struct SearchAlbum : Codable {
    
    let href : String?
    let id : String?
    let images : [SearchImage]?
    let name : String?
    let releaseDate : String?
    let releaseDatePrecision : String?
}

struct SearchImage : Codable {
    let url : String?
}

struct SearchArtist : Codable {
    let href : String?
    let id : String?
    let name : String?
    let type : String?
    let uri : String?
}
