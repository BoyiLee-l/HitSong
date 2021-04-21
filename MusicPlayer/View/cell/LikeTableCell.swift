//
//  LikeTableCell.swift
//  HitSong
//
//  Created by user on 2021/4/14.
//  Copyright © 2021 abc. All rights reserved.
//

import UIKit

class LikeTableCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myLabel.font = UIFont(name: "Title 1", size: 22)
        nameLabel.font = UIFont(name: "Title 1", size: 18)
        myLabel.textColor = .white
        nameLabel.textColor = .white
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
