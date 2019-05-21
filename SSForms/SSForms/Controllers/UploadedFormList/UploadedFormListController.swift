//
//  UploadedFormListController.swift
//  SSForms
//
//  Created by Suraj on 5/20/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit
import CoreData

class UploadedFormListController: UIViewController {

    @IBOutlet weak var uploadFileListTableView: UITableView!
    private var files = [UploadedForms]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        fetchUploadedFilesFromDB()
    }
    
    private func initialSetUp() {
        uploadFileListTableView.register(UINib(nibName: "UploadFormListViewCell",
                                               bundle: nil),
                                         forCellReuseIdentifier: "UploadFormListViewCell")
    }
    private func fetchUploadedFilesFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UploadedForms")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [UploadedForms] {
                files.append(data)
                print(data.value(forKey: "fileName") as! String)
            }
        } catch {
            print("Failed")
        }
    }
}
extension UploadedFormListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadFormListViewCell",
                                                       for: indexPath) as? UploadFormListViewCell else {
            return UITableViewCell()
        }
        cell.fileNameLabel.text = files[indexPath.row].fileName
        if files[indexPath.row].fileStatus == true {
            cell.uploadStatusButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            cell.uploadStatusButton.setImage(UIImage(named: "warning"), for: .normal)
        }
        return cell
    }
}
