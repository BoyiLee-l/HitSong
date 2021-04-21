//
//  PlayListRealm.swift
//  HitSong
//
//  Created by user on 2021/4/13.
//  Copyright © 2021 abc. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:Realm使用,我的最愛頁面用
class UserInfo: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var url: String = ""
    @objc dynamic var albumName: String = ""
    @objc dynamic var artistsName: String = ""
    @objc dynamic var songName: String = ""
    @objc dynamic var previewUrl: String = ""
    //收藏用
    @objc dynamic var collection: Bool = false
    override static func primaryKey() -> String? {
        return "id"
    }
}


class PlayListRealm {
    let realm = try! Realm()
    static let shared = PlayListRealm()
    
    //刪除
    func delete(info: UserInfo) {
        try? realm.write {
            realm.delete(info)
        }
    }
    
    //新增
    func addTrack(info: Track2) {
        let userInfo = UserInfo()
        userInfo.url = info.album?.images?[1].url ?? ""
        userInfo.albumName = info.album?.name ?? ""
        userInfo.artistsName = info.artists?.first?.name ?? ""
        userInfo.songName = info.name ?? ""
        userInfo.previewUrl = info.previewUrl ?? ""
        userInfo.collection = true
        try? realm.write {
            realm.add(userInfo)
        }
    }
    
    func addSearch(info: SearchItem) {
        let userInfo = UserInfo()
        userInfo.url = info.album?.images?[1].url ?? ""
        userInfo.albumName = info.album?.name ?? ""
        userInfo.artistsName = info.artists?.first?.name ?? ""
        userInfo.songName = info.name ?? ""
        userInfo.previewUrl = info.previewUrl ?? ""
        userInfo.collection = true
        try? realm.write {
            realm.add(userInfo)
        }
    }
    
    //查詢
    func fetchAll() -> [UserInfo] {
        var allData = [UserInfo]()
        let datas = realm.objects(UserInfo.self)
        for data in datas{
            allData.append(data)
        }
        return allData
    }
}
