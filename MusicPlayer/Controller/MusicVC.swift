//
//  MusicVC.swift
//  HitSong
//
//  Created by user on 2020/8/21.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class MusicVC: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet var timeLabel: [UILabel]!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var musucData = [Item2]()
    var searchData = [SearchItem]()
    //收藏使用
    var likeData = [UserInfo]()
    var userInfo =  UserInfo()//給收藏頁面使用
    var likeCollection: Bool = false
    var detailData: DetailData = .熱門清單
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    var timeObserverToken: Any?
    var songIndex: Int!
    var isPlaying = true
    
    var currentTimeInSec: Float!
    var totalTimeInSec: Float!
    var remainingTimeInSec: Float!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        setPlayerContent()
        playMusic()
        setBackgroundColor(color1: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                      color2: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
                      color3: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        print(likeCollection)
        if likeCollection == false{
            likeBtn.setImage(UIImage(named: "whiteheart"), for: .normal)
        }else{
            likeBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePeriodicTimeObserver()
    }
    
    //MARK:裝音樂資料
    func setPlayerContent(){
        switch detailData {
        case .熱門清單:
            guard let url = musucData[songIndex].track?.album?.images?.first?.url else { return  }
            songImageView.kf.setImage(with: URL(string: url))
            songNameLabel.text = musucData[songIndex].track?.name
            artistLabel.text = musucData[songIndex].track?.artists?.first?.name
            
            likeCollection = likeData.filter({ (userInfo) -> Bool in
                userInfo.previewUrl == musucData[songIndex].track?.previewUrl
            }).isEmpty ? false: true
        //            print(likeData[songIndex].previewUrl, "ddd")
        //            print(musucData[songIndex].track?.previewUrl, "aaa")
        case .收藏清單:
            let data = likeData[songIndex]
            let url = data.url
            songImageView.kf.setImage(with: URL(string: url))
            songNameLabel.text = data.songName
            artistLabel.text = data.artistsName
            likeCollection = true
        default :
            guard let url = searchData[songIndex].album?.images?.first?.url else { return }
            songImageView.kf.setImage(with: URL(string: url))
            songNameLabel.text = searchData[songIndex].name
            if searchData[songIndex].artists?.count == 1{
                artistLabel.text = searchData[songIndex].artists?.first?.name
            }else{
                artistLabel.text = "\(searchData[songIndex].artists?[0].name ?? ""),\(searchData[songIndex].artists?[1].name ?? "")"
            }
            likeCollection = likeData.filter({ (userInfo) -> Bool in
                userInfo.songName == searchData[songIndex].name
            }).isEmpty ? false: true
        }
    }
    
    // MARK: - Play Music
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if songIndex == 0{
                if detailData == .熱門清單{
                    songIndex = musucData.count - 1
                } else if detailData == .收藏清單 {
                    songIndex = likeData.count - 1
                } else {
                    songIndex = searchData.count - 1
                }
            }else{
                songIndex -= 1
            }
            print("sender1")
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            playMusic()
            
        case 2:
            isPlaying ? player.pause() : player.play()
            sender.setImage(UIImage(named: isPlaying ? "play-button" : "pause"), for: .normal)
            isPlaying = !isPlaying
        case 3:
            if detailData == .熱門清單{
                if songIndex == musucData.count - 1 {
                    songIndex = 0
                }else{
                    songIndex += 1
                }
            } else if detailData == .收藏清單 {
                if songIndex == likeData.count - 1 {
                    songIndex = 0
                }else{
                    songIndex += 1
                }
            } else {
                if songIndex == searchData.count - 1 {
                    songIndex = 0
                }else{
                    songIndex += 1
                }
            }
            print("sender3")
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            playMusic()
        default:
            print("playButton error")
        }
    }
    
    //MARK:播放音樂
    func playMusic() {
        removePeriodicTimeObserver()
        switch detailData {
        case .熱門清單:
            guard let musicUrl = musucData[songIndex].track?.previewUrl else { return }
            if let url = URL(string: musicUrl){
                playerItem = AVPlayerItem(url: url)
            }
        case .收藏清單:
            let musicUrl = likeData[songIndex].previewUrl
            if let url = URL(string: musicUrl){
                playerItem = AVPlayerItem(url: url)
            }
        default:
            guard let musicUrl = searchData[songIndex].previewUrl else { return }
            if let url = URL(string: musicUrl){
                playerItem = AVPlayerItem(url: url)
            }
        }
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        DispatchQueue.main.async {
            self.setPlayerContent()
        }
        // Time observer
        addPeriodicTimeObserver()
    }
    
    //MARk:讀取清單
    func read(){
        likeData = PlayListRealm.shared.fetchAll()
        print(likeData)
    }
    
    func alert(title: String, completion: ((UIAlertAction)-> Void)?) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: completion)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK:加入收藏
    @IBAction func like(_ sender: Any) {
        switch detailData {
        case .收藏清單:
            likeBtn.setImage(UIImage(named: "whiteheart"), for: .normal)
            PlayListRealm.shared.delete(info: likeData[songIndex])
            alert(title: "取消的我的收藏") { (_) in
                self.navigationController?.popViewController(animated: true)
            }
        case .搜尋清單:
            let allData: [UserInfo] = PlayListRealm.shared.fetchAll()
            let data = searchData[songIndex]
            let myFavorite = allData.filter ({ $0.songName == data.name }).isEmpty
            if myFavorite {
                let list = searchData[songIndex]
                PlayListRealm.shared.addSearch(info: list)
                likeBtn.setImage(UIImage(named: "heart"), for: .normal)
                alert(title: "已加入的我的歌單", completion: nil)
            } else {
                likeBtn.setImage(UIImage(named: "whiteheart"), for: .normal)
                let deleteData = allData.filter ({ ($0.songName == data.name)}).first ?? UserInfo()
                PlayListRealm.shared.delete(info: deleteData)
                alert(title: "從我的歌單移除", completion: nil)
            }
        default:
            let allData: [UserInfo] = PlayListRealm.shared.fetchAll()
            let data = musucData[songIndex]
            let myFavorite = allData.filter ({ $0.songName == data.track?.name ?? "" }).isEmpty
            if myFavorite {
                guard let list = musucData[songIndex].track else { return }
                PlayListRealm.shared.addTrack(info: list)
                likeBtn.setImage(UIImage(named: "heart"), for: .normal)
                alert(title: "已加入的我的歌單", completion: nil)
            } else {
                likeBtn.setImage(UIImage(named: "whiteheart"), for: .normal)
                let deleteData = allData.filter ({ ($0.songName == data.track?.name ?? "" )}).first ?? UserInfo()
                PlayListRealm.shared.delete(info: deleteData)
                alert(title: "從我的歌單移除", completion: nil)
            }
        }
    }
    
    // MARK: - Volume Setting
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        player.volume = sliderValue
    }
    
    @IBAction func volumeButtonPressed(_ sender: UIButton) {
        if sender.tag == 11 {
            player.isMuted = true
        } else {
            player.isMuted = false
        }
    }
    
    // MARK: - Music Progress
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            let duration = self?.playerItem.asset.duration
            let second = CMTimeGetSeconds(duration!)
            self!.totalTimeInSec = Float(second)
            let songCurrentTime = self?.player.currentTime().seconds
            self!.currentTimeInSec = Float(songCurrentTime!)
            self?.updateProgressUI()
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func updateProgressUI() {
        if timeConverter(currentTimeInSec) == timeConverter(totalTimeInSec) {
            removePeriodicTimeObserver()
            
            if songIndex == musucData.count - 1 {
                songIndex = 0
            }else{
                songIndex += 1
            }
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            playMusic()
            
        } else {
            remainingTimeInSec = totalTimeInSec - currentTimeInSec
            timeLabel[0].text = timeConverter(currentTimeInSec)
            timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
            songProgress.progress = currentTimeInSec / totalTimeInSec
        }
        
    }
    
    func timeConverter(_ timeInSecond: Float) -> String {
        let minute = Int(timeInSecond) / 60
        let second = Int(timeInSecond) % 60
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"
        
    }
}
