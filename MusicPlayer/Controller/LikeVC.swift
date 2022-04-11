//
//  LikeVC.swift
//  HitSong
//
//  Created by user on 2021/4/12.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class LikeVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var likeData = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSet()
        setBackgroundColor(color1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                      color2: #colorLiteral(red: 0.7451151609, green: 0.7450172305, blue: 0.7536247373, alpha: 1),
                      color3: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        self.navigationItem.title = "我的播放清單"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
        tabBarController?.selectedIndex = 2
    }
    
    func tableSet(){
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = .clear
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(named: "DarkGreen")
    }
    
    func setData(){
        likeData = PlayListRealm.shared.fetchAll()
        myTableView.reloadData()
    }
}

extension LikeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LikeTableCell
        let data = likeData[indexPath.row]
        cell.myLabel.text = data.artistsName
        cell.nameLabel.text = data.songName
        let urls = data.url
        cell.myImage.kf.setImage(with: URL(string: urls), placeholder: UIImage(named: "noPhoto"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MusicVC") as! MusicVC
        guard let row = myTableView.indexPathForSelectedRow?.row else { return }
        next.likeData = self.likeData
        next.detailData = .收藏清單
        next.songIndex = row
        self.present(next, animated: true, completion: nil)
    }
    
    //刪除方法
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = likeData[indexPath.row]
            PlayListRealm.shared.delete(info: data)
            likeData.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    }
}
