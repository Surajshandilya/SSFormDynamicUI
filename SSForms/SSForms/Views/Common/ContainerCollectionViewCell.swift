//
//  ContainerCollectionViewCell.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation
import Cartography
class ContainerCollectionViewCell: UICollectionViewCell {
    // Outlet are required if initialized from nib
    @IBOutlet var containerView: UIView!
    
    var width: CGFloat = 320 { didSet { widthConstraint?.constant = width } }
    
    private var widthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        self.containerView = UIView()
        super.init(frame: frame)
        contentView.addSubview(containerView)
        constrain(containerView, contentView) { containerView, superview in
            containerView.edges == superview.edges
        }
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        addConstraints()
    }
    
    func addConstraints() {
        constrain(containerView) { containerView in
            widthConstraint = (containerView.width == width)
        }
        constrain(contentView, self) { contentView, cell in
            contentView.edges == cell.edges
        }
    }
}
