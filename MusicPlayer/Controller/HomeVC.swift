//
//  ViewController.swift
//  HitSong
//
//  Created by user on 2020/8/18.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Network

enum DetailData {
    case 熱門清單
    case 他類清單
    case 搜尋清單
    case 收藏清單
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    var hrefURl = ""
    var titleName = ""
    var detailData: DetailData = .熱門清單
    
    var results = GetspotifyData()
    var spotifyData: PlaylistsData?
    
    let monitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(hrefURl)
        checkNetwork()
        setCollectionView()
        setupActivityView()
        setBackgroundColor(color1: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                      color2: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                      color3: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }

    func setCollectionView() {
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = UIScreen.main.bounds.width / 2-6
        layout.itemSize = CGSize(width: width, height: width)
        myCollection.collectionViewLayout = layout
    }
    
    func requestData(){
        startLoading()
        switch detailData{
        case.熱門清單:
            results.getSpotifyData(baseurl: SpotifyAPIEndpoints.featuredPlaylistsURL) { (data) in
                self.spotifyData = data
                self.navigationItem.title = "熱門播放清單"
                self.stopLoading()
                self.myCollection.reloadData()
            }
        case .他類清單:
            results.getSpotifyData(baseurl: hrefURl) { (data) in
                self.spotifyData = data
                self.navigationItem.title = "\(self.titleName)"
                self.stopLoading()
                self.myCollection.reloadData()
            }
        default:
            break
        }
    }
    
    func checkNetwork(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
                self.requestData()
            } else {
                print("no connection")
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "網路異常", message: "請檢查網路相關設定", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotifyData?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionCell
        guard let data =  spotifyData?.items  else {fatalError()}
        let urls = data[indexPath.row].images?[0].url
        cell.myImage?.kf.setImage(with: URL(string: urls ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let next = self.storyboard?.instantiateViewController(withIdentifier: "TracksVC") as? TracksVC {
            //傳送data網址
            next.urls = String(spotifyData?.items?[indexPath.row].tracks?.href ?? "")
            //跳頁
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
}

