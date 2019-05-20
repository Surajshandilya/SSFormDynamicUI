//
//  UploadedFormListController.swift
//  SSForms
//
//  Created by Suraj on 5/20/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class UploadedFormListController: UIViewController {

    @IBOutlet weak var uploadFileListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        uploadFileListTableView.register(UINib(nibName: "UploadFormListViewCell",
                                               bundle: nil),
                                         forCellReuseIdentifier: "UploadFormListViewCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UploadedFormListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadFormListViewCell",
                                                       for: indexPath) as? UploadFormListViewCell else {
            return UITableViewCell()
        }
        cell.fileNameLabel.text = "Uploaded Files"
        return cell
    }
}
