//
//  UploadFormListViewCell.swift
//  SSForms
//
//  Created by Suraj on 5/20/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class UploadFormListViewCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var uploadStatusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
