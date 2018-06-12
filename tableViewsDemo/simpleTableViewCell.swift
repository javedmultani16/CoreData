//
//  simpleTableViewCell.swift
//  tableViewsDemo
//
//  Copyright © 2018 MyCompany. All rights reserved.
//

import UIKit

class simpleTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewFruit: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
