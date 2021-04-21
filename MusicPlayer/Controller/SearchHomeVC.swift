//
//  SerchHomeVC.swift
//  HitSong
//
//  Created by user on 2020/8/24.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import Network

@available(iOS 12.0, *)
class SearchHomeVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var results = GetspotifyData()
    var spotifyData: Categories?
    var searchData: [SearchItem] = []
    var filterArray: [Item] = []
    open var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    open var searchController: UISearchController!
    let monitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetwork()
        tableSet()
        searchSet()
        setBackground(color1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), color2: #colorLiteral(red: 0.7451151609, green: 0.7450172305, blue: 0.7536247373, alpha: 1), color3: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func requestData(){
        print("Categories:\(categoriesURL)")
        //startLoading()
        results.getCategories(baseurl: categoriesURL) { (data) in
            self.spotifyData = data
            //self.searchFilter()
            self.navigationItem.title = "搜尋"
            self.stopLoading()
            self.myTableView.reloadData()
        }
    }
    
    //MARK:檢察網路
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
    
    func tableSet(){
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(named: "DarkGreen")
        
    }
    
    func searchSet(){
//        navigationController?.navigationBar.prefersLargeTitles = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .black
        //self.searchController.searchBar.backgroundColor = .black
        searchController.searchBar.placeholder = "藝人,歌曲或專輯"
        // 搜尋框的樣式
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self // 設定代理UISearchResultsUpdating的協議
        searchController.searchBar.delegate = self // 設定代理UISearchBarDelegate的協議
//        searchController.dimsBackgroundDuringPresentation = false
        // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func gatSearchURl(value: String) -> String{
        return  "https://api.spotify.com/v1/search?q=\(value)&type=track&limit=50"
    }
}

@available(iOS 12.0, *)
extension SearchHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowSearchResult == true{
            return searchData.count
        }else{
            guard let data = spotifyData?.categories?.items else{ return 0}
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchHomeCell
        if self.isShowSearchResult == true{
            let data = searchData[indexPath.row]
            cell.myLabel.text = data.name
            let url = data.album?.images?[1].url
            cell.myImage?.kf.setImage(with:  URL(string: url ?? ""))
            cell.nameLabel.text = "歌手: \(data.artists?.first?.name ?? "")"
        }else{
            guard let data = spotifyData?.categories?.items[indexPath.row] else{ fatalError() }
            cell.myLabel.text = data.name
            let url = data.icons.first?.url
            cell.myImage?.kf.setImage(with:  URL(string: url ?? ""))
            cell.nameLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK:有搜尋結果
        if self.isShowSearchResult == true{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MusicVC") as! MusicVC
            guard let row = myTableView.indexPathForSelectedRow?.row else { return  }
            next.searchData = self.searchData
            next.songIndex = row
            next.detailData = .搜尋清單
            present(next, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(next, animated: true)
        }else{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            guard let data = spotifyData?.categories?.items[indexPath.row] else{ fatalError() }
            print("id:\(data.id)")
            let id = "\(data.id)"
            next.hrefURl = "https://api.spotify.com/v1/browse/categories/\(id)/playlists"
            next.titleName = "\(data.name)"
            next.detailData = .他類清單
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

@available(iOS 12.0, *)
extension SearchHomeVC: UISearchBarDelegate{
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyWord  = searchController.searchBar.text ?? ""
        guard let encodeUrlString = keyWord.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        print("searchURL:\(gatSearchURl(value: encodeUrlString))")
        startLoading()
        results.getSearchData(baseurl: gatSearchURl(value: encodeUrlString)) { (data) in
            guard let newData = data.tracks.items else { return }
            print(newData)
            self.searchData = newData.filter({($0.previewUrl != nil) })
            self.stopLoading()
            self.myTableView.reloadData()
        }
        isShowSearchResult = true
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isShowSearchResult = false
        myTableView.reloadData()
    }
}

@available(iOS 12.0, *)
extension SearchHomeVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController.searchBar.text == "" {
            return
        }
    }
}
