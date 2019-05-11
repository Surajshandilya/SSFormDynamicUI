//
//  ReuseIdentifiable.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable where Self: UICollectionViewCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

extension ReuseIdentifiable where Self: UICollectionReusableView {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
