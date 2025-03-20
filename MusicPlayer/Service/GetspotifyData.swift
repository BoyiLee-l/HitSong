//
//  getspotifyTrackData.swift
//  HitSong
//
//  Created by user on 2020/8/18.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetspotifyData: UIViewController {
    
    // 單獨取得 access token 的方法
    func fetchAccessToken(completion: @escaping (String?) -> Void) {
        let parameters: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": "AQDldCO_XnSNDaUVNpaquIlbVwTEIDys0V5pg7E2JVPYjdPKjlcatYbvnMlvQO473lmkR4vJAifiOV2wTFuBtX03E7ekv35BHyYXcG08aA4M0ruxB6hW7xklduA3mJ26YUI"
        ]
        
        let tokenHeaders: HTTPHeaders = [
            "Authorization": "Basic MGJlNzEyYTliZWMzNDU1MTg4ODFlMzI4NWY1NmEwMzk6ZTYwYWFjZjcwODEzNDk0MGFkYzIxZjVjY2Y3NzkzNTI=",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        AF.request("https://accounts.spotify.com/api/token",
                   method: .post, // 建議使用 POST 方法
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: tokenHeaders)
        .responseJSON { tokenResponse in
            switch tokenResponse.result {
            case .success(let tokenValue):
                let tokenJSON = JSON(tokenValue)
                let accessToken = tokenJSON["access_token"].stringValue
                print("Access Token: \(accessToken)")
                completion(accessToken)
            case .failure(let error):
                print("Error fetching token: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    func getSpotifyData(baseurl: String, completion: @escaping (PlaylistsData) -> Void) {
        fetchAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Failed to fetch access token")
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)"
            ]
            
            AF.request(baseurl, method: .get, headers: headers)
                .responseData { dataResponse in
                    switch dataResponse.result {
                    case .success(let data):
                        // 印出回傳的 JSON 資料
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("JSON response:\n\(jsonString)")
                        } else {
                            print("無法轉換 data 為 JSON 字串")
                        }
                        
                        do {
                            let playlistsData = try JSONDecoder().decode(PlaylistsData.self, from: data)
                            print("Playlists Data: \(playlistsData)")
                            completion(playlistsData)
                        } catch {
                            print("Decoding error: \(error.localizedDescription)")
                        }
                    case .failure(let error):
                        print("Error fetching Spotify data: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    //MARK: -TracksData
    func getTracksData(baseurl: String, completion: @escaping(TracksData) ->Void){
        //refresh_token
        let parameters = "grant_type=refresh_token&refresh_token=AQDldCO_XnSNDaUVNpaquIlbVwTEIDys0V5pg7E2JVPYjdPKjlcatYbvnMlvQO473lmkR4vJAifiOV2wTFuBtX03E7ekv35BHyYXcG08aA4M0ruxB6hW7xklduA3mJ26YUI"
        let postData =  parameters.data(using: .utf8)
        if let url = URL(string: "https://accounts.spotify.com/api/token"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //Client ID:你的Client Secret
            request.addValue("Basic MGJlNzEyYTliZWMzNDU1MTg4ODFlMzI4NWY1NmEwMzk6ZTYwYWFjZjcwODEzNDk0MGFkYzIxZjVjY2Y3NzkzNTI=", forHTTPHeaderField: "Authorization")
            request.httpBody = postData
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let json = try! JSON(data: data!)
                let token = json["access_token"].stringValue
                let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
                
                AF.request(baseurl, headers: headers).responseJSON { response in
                    
                    if let data = response.data {
                        do {
                            let dataList = try JSONDecoder().decode(TracksData.self, from: data)
                            completion(dataList)
                            //print(dataList)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
    
    //MARK: -Categories
    func getCategories(baseurl: String, completion: @escaping(Categories) ->Void){
        //refresh_token
        let parameters = "grant_type=refresh_token&refresh_token=AQDldCO_XnSNDaUVNpaquIlbVwTEIDys0V5pg7E2JVPYjdPKjlcatYbvnMlvQO473lmkR4vJAifiOV2wTFuBtX03E7ekv35BHyYXcG08aA4M0ruxB6hW7xklduA3mJ26YUI"
        let postData =  parameters.data(using: .utf8)
        if let url = URL(string: "https://accounts.spotify.com/api/token"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //Client ID:你的Client Secret
            request.addValue("Basic MGJlNzEyYTliZWMzNDU1MTg4ODFlMzI4NWY1NmEwMzk6ZTYwYWFjZjcwODEzNDk0MGFkYzIxZjVjY2Y3NzkzNTI=", forHTTPHeaderField: "Authorization")
            request.httpBody = postData
            
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let json = try! JSON(data: data!)
                let token = json["access_token"].stringValue
                let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
                
                AF.request(baseurl, headers: headers).responseJSON { response in
                    //                    print(response)
                    if let data = response.data {
                        do {
                            let dataList = try JSONDecoder().decode(Categories.self, from: data)
                            completion(dataList)
                            //print(dataList)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    //MARK: -SearchData
    func getSearchData(baseurl: String, completion: @escaping(SearchData) ->Void){
        //refresh_token
        let parameters = "grant_type=refresh_token&refresh_token=AQDldCO_XnSNDaUVNpaquIlbVwTEIDys0V5pg7E2JVPYjdPKjlcatYbvnMlvQO473lmkR4vJAifiOV2wTFuBtX03E7ekv35BHyYXcG08aA4M0ruxB6hW7xklduA3mJ26YUI"
        let postData =  parameters.data(using: .utf8)
        if let url = URL(string: "https://accounts.spotify.com/api/token"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //Client ID:你的Client Secret
            request.addValue("Basic MGJlNzEyYTliZWMzNDU1MTg4ODFlMzI4NWY1NmEwMzk6ZTYwYWFjZjcwODEzNDk0MGFkYzIxZjVjY2Y3NzkzNTI=", forHTTPHeaderField: "Authorization")
            request.httpBody = postData
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let json = try! JSON(data: data!)
                let token = json["access_token"].stringValue
                let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
                
                AF.request(baseurl, headers: headers).responseJSON { response in
                    if let data = response.data {
                        do {
                            let dataList = try JSONDecoder().decode(SearchData.self, from: data)
                            completion(dataList)
                            print(dataList)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
}


