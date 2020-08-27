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

enum DetailData {
    case 熱門清單
    case 他類清單
    case 搜尋清單
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    var hrefURl = ""
    var titleName = ""
    var detailData: DetailData = .熱門清單
    
    var results = GetspotifyData()
    var spotifyData: PlaylistsData?
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .white
        return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(hrefURl)
        requestData()
        setCollectionView()
        setupActivityView()
    }
    
    func setCollectionView() {
        myCollection.delegate = self
        myCollection.dataSource = self
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
            results.getSpotifyData(baseurl: baseURL) { (data) in
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
        case .搜尋清單:
            break
        }
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        guard let data =  spotifyData?.playlists?.items  else {fatalError()}
        return spotifyData?.playlists?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionCell
        guard let data =  spotifyData?.playlists?.items  else {fatalError()}
        let urls = data[indexPath.row].images?[0].url
        cell.myImage?.kf.setImage(with: URL(string: urls ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let next = self.storyboard?.instantiateViewController(withIdentifier: "TracksVC") as? TracksVC {
            //傳送data網址
            next.urls = String(spotifyData?.playlists?.items?[indexPath.row].tracks?.href ?? "")
            //跳頁
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
}
