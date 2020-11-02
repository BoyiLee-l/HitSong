//
//  MusicVC.swift
//  HitSong
//
//  Created by user on 2020/8/21.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import AVFoundation


class MusicVC: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet var timeLabel: [UILabel]!
    @IBOutlet weak var playButton: UIButton!
    var musucData = [Item2]()
    var searchData = [SearchItem]()
    
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
        playMusic()
        setBackground(color1: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), color2: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), color3: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePeriodicTimeObserver()
    }
    
    func setPlayerContent(){
        if detailData == .熱門清單{
            guard let url = musucData[songIndex].track?.album?.images?.first?.url else { return  }
            songImageView.kf.setImage(with: URL(string: url))
            songNameLabel.text = musucData[songIndex].track?.name
            artistLabel.text = musucData[songIndex].track?.artists?.first?.name
        }else{
            guard let url = searchData[songIndex].album?.images?.first?.url else { return }
            songImageView.kf.setImage(with: URL(string: url))
            songNameLabel.text = searchData[songIndex].name
            if searchData[songIndex].artists?.count == 1{
                artistLabel.text = searchData[songIndex].artists?.first?.name
            }else{
                artistLabel.text = "\(searchData[songIndex].artists?[0].name ?? ""),\(searchData[songIndex].artists?[1].name ?? "")"
            }
        }
    }
    
    // MARK: - Play Music
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if songIndex == 0{
                if detailData == .熱門清單{
                    songIndex = musucData.count - 1
                }else{
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
            }else{
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
    
    func playMusic() {
        removePeriodicTimeObserver()
        
        if detailData == .熱門清單{
            guard let musicUrl = musucData[songIndex].track?.previewUrl else { return  }
            if let url = URL(string: musicUrl){
                playerItem = AVPlayerItem(url: url)
            }
        }else{
            guard let musicUrl = searchData[songIndex].previewUrl else { return  }
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
