//
//  FormSelectiveOptionViewCell.swift
//  SSForms
//
//  Created by Suraj on 5/19/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class FormSelectiveOptionViewCell: ContainerCollectionViewCell, ReuseIdentifiable, StaticCellable {
    static var totalCellHeight: CGFloat { return 40 }
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var firstOptionLabel: UILabel!
    @IBOutlet weak var secondOptionLabel: UILabel!
    @IBOutlet weak var firstSelectiveButton: UIButton!
    @IBOutlet weak var secondSelectiveButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func firstSelectiveButtonChecked(_ sender: Any) {
    }
    @IBAction func secondSelectiveButtonChecked(_ sender: Any) {
    }
}
