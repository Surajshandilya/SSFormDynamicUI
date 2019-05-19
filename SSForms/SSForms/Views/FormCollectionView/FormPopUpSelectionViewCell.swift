//
//  FormPopUpSelectionViewCell.swift
//  SSForms
//
//  Created by Suraj on 5/19/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class FormPopUpSelectionViewCell: ContainerCollectionViewCell, ReuseIdentifiable, StaticCellable {
    @IBOutlet weak var selectTitleLabel: UILabel!
    @IBOutlet weak var popUpButton: UIButton!
    
    // StaticCellable Protocol
    static var totalCellHeight: CGFloat { return 33 }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func showPopUpList(_ sender: Any) {
    }
}
