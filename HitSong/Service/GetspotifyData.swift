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

class GetspotifyData {
    
    //MARK: -PlaylistsData
    func getSpotifyData(baseurl: String, completion: @escaping(PlaylistsData) ->Void){
        //refresh_token
        let parameters = "grant_type=refresh_token&refresh_token=AQDldCO_XnSNDaUVNpaquIlbVwTEIDys0V5pg7E2JVPYjdPKjlcatYbvnMlvQO473lmkR4vJAifiOV2wTFuBtX03E7ekv35BHyYXcG08aA4M0ruxB6hW7xklduA3mJ26YUI"
        let postData =  parameters.data(using: .utf8)
        if let url = URL(string: "https://accounts.spotify.com/api/token"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            //Client ID:你的Client Secret
            request.addValue("Basic MGJlNzEyYTliZWMzNDU1MTg4ODFlMzI4NWY1NmEwMzk6ZTYwYWFjZjcwODEzNDk0MGFkYzIxZjVjY2Y3NzkzNTI=", forHTTPHeaderField: "Authorization")
            // request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //            request.addValue("__Host-device_id=AQCc6FBug-8RjMBI2-PLYGAVufVyY_abzPxvqoNT4evhZ2vt_ie26IUz04J4RKCC_nhhU8cIoX9zlkuxW9sN0_4MnLCtTQ9sdbQ", forHTTPHeaderField: "Cookie")
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let json = try! JSON(data: data!)
                let token = json["access_token"].stringValue
                print(token)
                
                //let url: String = "https://api.spotify.com/v1/browse/featured-playlists?country=TW"
                
                let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
                
                AF.request(baseurl, headers: headers).responseJSON { response in
                    if let data = response.data {
                        do {
                            let dataList = try JSONDecoder().decode(PlaylistsData.self, from: data)
                            completion(dataList)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
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
                            //print(dataList)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.resume()
        }
    }
}


