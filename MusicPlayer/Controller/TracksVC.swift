//
//  TracksVC.swift
//  HitSong
//
//  Created by user on 2020/8/20.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class TracksVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var urls = ""
    var musicId = ""
    var results = GetspotifyData()
    var musucData: [PlaylistTrackItem] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        tableSet()
        setupActivityView()
        setBackgroundColor(color1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                      color2: #colorLiteral(red: 0.7451151609, green: 0.7450172305, blue: 0.7536247373, alpha: 1),
                      color3: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func tableSet(){
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(named: "DarkGreen")
    }
    
    func requestData(){
        print("TrackVCURL:\(SpotifyAPIEndpoints.trackURL(for: musicId))")
        startLoading()
        results.getTracksData(baseurl: urls) { (data) in
            guard let newData = data.items else { return }
            self.musucData = newData.filter({ ($0.track?.previewUrl != nil)})
            //print(self.musucData)
            self.stopLoading()
            self.myTableView.reloadData()
        }
    }
}

extension TracksVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musucData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TracksTableCell
        cell.delegate = self
        let data = musucData[indexPath.row]
        let url = data.track?.album?.images?[1].url
        cell.myImage?.kf.setImage(with:  URL(string: url ?? ""))
        cell.albumName.text = data.track?.album?.name
        cell.artistsName.text = data.track?.artists?.first?.name
        cell.songName.text = data.track?.name
        cell.musicUrl = String(data.track?.previewUrl ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MusicVC") as! MusicVC
        guard let row = myTableView.indexPathForSelectedRow?.row else { return }
        next.musucData = self.musucData
        next.songIndex = row
        self.present(next, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension TracksVC: TracksDelegate{
    
    func playMusic(url: URL) {
        
        //        let playerItem = AVPlayerItem(url: url)
        //        player.replaceCurrentItem(with: playerItem)
        //        player.volume = 0.6
        //        player.play()
        //
    }
    
    
}
