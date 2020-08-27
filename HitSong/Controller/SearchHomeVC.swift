//
//  SerchHomeVC.swift
//  HitSong
//
//  Created by user on 2020/8/24.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class SearchHomeVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var results = GetspotifyData()
    var spotifyData: Categories?
    var searchData: [SearchItem] = []
    var filterArray: [Item] = []
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    var searchController: UISearchController!
    
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .white
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        tableSet()
        searchSet()
        
    }
    
    func requestData(){
        print("Categories:\(categoriesURL)")
        startLoading()
        results.getCategories(baseurl: categoriesURL) { (data) in
            self.spotifyData = data
            //self.searchFilter()
            self.navigationItem.title = "搜尋"
            self.stopLoading()
            self.myTableView.reloadData()
        }
    }
    
//    func searchFilter()->([CategoriesItem]){
//        guard let datas = spotifyData?.categories?.items else{ fatalError() }
//
//        for data in datas{
//            let hrefURl = searchFilterURL(id: data.id)
//            results.getSpotifyData(baseurl: hrefURl) { (PlaylistsData) in
//                PlaylistsData.playlists?.items?.filter({ ($0 != nil)})
//
//            }
//        }
//        return datas
//    }
//
//    func searchFilterURL(id: String) -> String{
//        return  "https://api.spotify.com/v1/browse/categories/\(id)/playlists"
//    }
    
    
    func tableSet(){
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(named: "DarkGreen")
        
        let colour1 = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        let colour2 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [colour2, colour1]
        gradient.locations = [ 0.4,0.8]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func searchSet(){
        // 生成SearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.placeholder = "藝人,歌曲或專輯"
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self // 設定代理UISearchResultsUpdating的協議
        self.searchController.searchBar.delegate = self // 設定代理UISearchBarDelegate的協議
        self.searchController.dimsBackgroundDuringPresentation = false // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        // 將searchBar掛載到tableView上
        self.myTableView.tableHeaderView = self.searchController.searchBar
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
    
    func gatSearchURl(value: String) -> String{
        return  "https://api.spotify.com/v1/search?q=\(value)&type=track&limit=50"
    }
}

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
        
        if self.isShowSearchResult == true{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MusicVC") as! MusicVC
            guard let row = myTableView.indexPathForSelectedRow?.row else { return  }
            next.searchData = self.searchData
            next.songIndex = row
            next.detailData = .搜尋清單
            present(next, animated: true, completion: nil)
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

extension SearchHomeVC: UISearchBarDelegate{
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyWord  = self.searchController.searchBar.text ?? ""
        guard let encodeUrlString = keyWord.addingPercentEncoding(withAllowedCharacters:
            .urlHostAllowed) else {
                return
        }
        print("searchURL:\(gatSearchURl(value: encodeUrlString))")
        startLoading()
        results.getSearchData(baseurl: gatSearchURl(value: encodeUrlString)) { (data) in
            //print(self.searchData)
            guard let newData = data.tracks.items else { return }
            self.searchData = newData.filter({($0.previewUrl != nil) })
//            self.navigationItem.title = "搜尋列表"
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

extension SearchHomeVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController.searchBar.text == "" {
            return
        }
    }
    
    
}
