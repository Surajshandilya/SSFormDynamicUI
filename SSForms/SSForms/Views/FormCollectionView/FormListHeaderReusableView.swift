//
//  FormListHeaderReusableView.swift
//  SSForms
//
//  Created by Suraj on 5/19/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit
protocol FormListHeaderReusableViewDelegate: class {
    func toggleBtnTapped(_ headerView: FormListHeaderReusableView, didTapToggleButton button: UIButton)
}
class FormListHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var sectionHeaderLabel: UILabel!
    @IBOutlet weak var toggleExpandCollapseButton: UIButton!
    @IBOutlet weak var toogleHeaderButton: UIButton!
    weak var delegate: FormListHeaderReusableViewDelegate?

    
    @IBAction func toggleExpandCollapse(_ sender: UIButton) {
        delegate?.toggleBtnTapped(self, didTapToggleButton: sender)
    }
    
}
