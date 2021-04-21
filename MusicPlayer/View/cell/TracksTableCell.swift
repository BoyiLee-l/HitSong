//
//  TracksTableCell.swift
//  HitSong
//
//  Created by user on 2020/8/21.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class TracksTableCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistsName: UILabel!
   
    
    weak var delegate: TracksDelegate?
    var musicUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumName.font =  UIFont(name: "Title 1", size: 14)
        songName.font = UIFont(name: "Title 2", size: 14)
        artistsName.font = UIFont(name: "Title 1", size: 14)
        
        albumName.textColor = .white
        songName.textColor = .white
        artistsName.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

protocol TracksDelegate: class {
    func playMusic(url: URL)
}
