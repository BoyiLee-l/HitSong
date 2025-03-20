//
//  SpotifyAPIEndpoints.swift
//  MusicPlayer
//
//  Created by Duncan Li on 2025/3/20.
//  Copyright © 2025 abc. All rights reserved.
//

import Foundation

struct SpotifyAPIEndpoints {
    /// Spotify 使用者播放清單（Featured Playlists）的 URL，限制 10 筆，從第 6 筆開始（offset=5）
    static let featuredPlaylistsURL = "https://api.spotify.com/v1/me/playlists?limit=10&offset=5"
    
    /// Spotify 類別清單的 URL，返回 50 個分類項目，從第一筆開始（offset=0）
    static let categoriesURL = "https://api.spotify.com/v1/browse/categories?offset=0&limit=50"
    
    /// 根據曲目 id 產生取得曲目資訊的 URL
    static func trackURL(for id: String) -> String {
        return "https://api.spotify.com/v1/tracks/\(id)"
    }
}

struct SpotifyAPIParameters {
    static var keyWord: String = ""
}
