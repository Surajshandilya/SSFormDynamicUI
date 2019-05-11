//
//  HomeViewController.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    private var formCoordinator: FormCoordinator?
    @IBAction func showFillForm(_ sender: Any) {

        let onBack: ((FormCoordinator) -> Void) = { [weak self] coordinator in
            guard let sSelf = self else { return }
            guard sSelf.formCoordinator == coordinator else { return }
            sSelf.formCoordinator = nil
        }
        self.formCoordinator = FormCoordinator(formVC: self, onBack: onBack)
        self.formCoordinator?.start()
    }
}
