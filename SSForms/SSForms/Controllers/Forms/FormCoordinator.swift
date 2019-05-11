//
//  FormCoordinator.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation
import UIKit

final class FormCoordinator: NSObject {
    weak var formViewController: UIViewController?
    private weak var navigationViewController: UINavigationController?
    private let onBack: (FormCoordinator) -> Void
    
    init(formVC: UIViewController, onBack: @escaping (FormCoordinator) -> Void) {
        self.formViewController = formVC
        self.navigationViewController = self.formViewController?.navigationController
        self.onBack = onBack
    }
    func start() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let formVC = storyBoard.instantiateViewController(withIdentifier: "FormVCStoryBoardId") as? FormViewController else { return }
        self.formViewController = formVC
        self.navigationViewController?.pushViewController(formVC, animated: true)
    }
}
