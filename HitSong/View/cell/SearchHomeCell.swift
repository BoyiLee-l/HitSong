//
//  SerchHomeCell.swift
//  HitSong
//
//  Created by user on 2020/8/25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class SearchHomeCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myLabel.font = UIFont(name: "Title 1", size: 22)
        nameLabel.font = UIFont(name: "Title 1", size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
