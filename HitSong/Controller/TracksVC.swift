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
    
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .white
        return activityView
    }()
    var urls = ""
    var results = GetspotifyData()
    var musucData: [Item2] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        tableSet()
        setupActivityView()
    }
    
    func requestData(){
        print("TrackVCURL:\(urls)")
        startLoading()
        results.getTracksData(baseurl: urls) { (data) in
            guard let newData = data.items else { return }
            self.musucData = newData.filter({ ($0.track?.previewUrl != nil)})
            //print(self.musucData)
            self.stopLoading()
            self.myTableView.reloadData()
        }
    }
    
    func tableSet(){
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(named: "DarkGreen")
        // UI design
        //let colour1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        let colour1 = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour2, colour1]
        gradient.locations = [ 0.4,0.8]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupActivityView(){
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func startLoading(){
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func stopLoading(){
        spinner.stopAnimating()
        spinner.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let next = segue.destination as! MusicVC
            guard let row = myTableView.indexPathForSelectedRow?.row else { return  }
            next.musucData = self.musucData
            next.songIndex = row
        }
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
