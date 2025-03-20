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
    
    var hrefURL = ""
    var titleName = ""
    var detailData: DetailData = .熱門清單
    
    var results = GetspotifyData()
    var spotifyData: PlaylistsData?
    
    let monitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(hrefURL)
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
        
        // 設定 section 的邊距與 cell 之間的間距
        let sectionInset: CGFloat = 10  // 左右邊距
        let interItemSpacing: CGFloat = 10  // 兩個 cell 之間的間距
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = interItemSpacing
        
        // 計算每個 cell 的寬度 = (螢幕寬度 - 左右邊距 - cell 之間的間距) / 2
        let itemWidth = (UIScreen.main.bounds.width - 2 * sectionInset - interItemSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
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
            results.getSpotifyData(baseurl: hrefURL) { (data) in
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
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
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

