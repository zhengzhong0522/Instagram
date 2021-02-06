//
//  CommentCell.swift
//  Instagram
//
//  Created by zhong zheng on 2/5/21.
//  Copyright © 2021 ZHONG ZHENG. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
