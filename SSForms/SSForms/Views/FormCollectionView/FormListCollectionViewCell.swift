//
//  FormListCollectionViewCell.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class FormListCollectionViewCell: ContainerCollectionViewCell, ReuseIdentifiable, StaticCellable {
    
    // StaticCellable Protocol
    static var totalCellHeight: CGFloat { return 81 }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
}
extension FormListCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textField== \(String(describing: textField.text))")
    }
}
