//
//  Section.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation
struct Section {
    var isExpanded: Bool
    var cellsIdentifier: [String]
    var sectionTitle: String
    init() {
        isExpanded = false
        cellsIdentifier = []
        sectionTitle = ""
    }
}
