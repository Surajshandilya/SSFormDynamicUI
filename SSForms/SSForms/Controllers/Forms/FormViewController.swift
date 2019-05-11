//
//  FormViewController.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

/*
{
    "users": [
    {
    "firstName": "John",
    "lastName": "Rey"
    },
    {
    "firstName": "Mathew",
    "lastName": "More"
    }
    ]
}
*/

import UIKit

class FormViewController: UIViewController {
    //Web service -- http://77.68.84.237/HixService/EMIS.svc/help
    //There three different file upload functions. Use whichever one works best for you.
    struct User: Codable {
        var userId: Int
        var id: Int
        var title: String
        var completed: Bool
    }
    @IBOutlet weak var formListCollectionView: UICollectionView!
    @IBOutlet weak var viewLoader: SSActivityIndicatorView!
    
    private let jsonObject: [String: Any] = [
        "type": "object",
        "required": [
            "age"
        ],
        "properties": {[
            "firstName": [
                "type": "string",
                "minLength": 2,
                "maxLength": 20
            ],
            "lastName": [
                "type": "string",
                "minLength": 5,
                "maxLength": 15
            ],
            "age": [
                "type": "integer",
                "minimum": 18,
                "maximum": 100
            ],
            "gender": [
                "type": "string",
                "enum": [
                "Male",
                "Female",
                "Undisclosed"
                ]
            ]
            ]},
        "custom": "hj"
    ]
    
    
    var sectionTitles: [String] = [""]
    private var xibCellsToRegister: [UICollectionViewCell.Type] {
        return [FormListCollectionViewCell.self]
    }
    var sections: [Section] = []
    var firstName: String?
    var lastName: String?
    var address: String?
    var gender: String?
    var getFormModels = [GetFormModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check jsonObject is valid or not
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // tru
        print("is valid json: \(valid)")
        guard let url = Bundle.main.url(forResource: "form", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(object)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(object: dictionary)
            }
        } catch {
            print(error.localizedDescription)
        }
       
//self.viewLoader.startAnimating(withUserInteration: false)
//        makeApiCall()
        setupCollectionView()
//        initialSectionSetup()
    }
    func readJSONObject(object: [String: AnyObject]) {
        guard let users = object["users"] as? [[String: AnyObject]] else { return }
//        for user in users {
//            guard let firstName = user["firstName"] as? String,
//                let lastName = user["lastName"] as? String else { break }
//            let model = GetFormModel(firstName: firstName, lastName: lastName)
//            getFormModels.append(model)
//            let str = ""
//            sectionTitles.append(str)
//        }
        for i in 1..<users.count {
            let str = ""
            sectionTitles.append(str)
        }
//        print("all models: \(getFormModels)")
        //Update first sectionTitle
        dynamicInitialSectionSetup()
    }
    private func getSingleDecodeModel() {
            let jsonString = """
        {
            "FirstName": "John",
            "LastName": "Doe",
        }
        """
        if let jsonData = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                // decoding our data
                let formModel = try decoder.decode(GetFormModel.self, from: jsonData)
                print(formModel)
                //Encoding data
                let jsonData = try! JSONEncoder().encode(formModel)
                //Convert data into Json Str
                let encodeJsonString = String(data: jsonData, encoding: .utf8)!
                print(encodeJsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func getArrayOfDecodeModel() {
                let jsonString = """
        [{
        "FirstName": "Federico",
         "LastName": "Zanetello",
        },{
        "FirstName": "John",
         "LastName": "Doe",
        },{
        "FirstName": "King",
         "LastName": "Raj",
        }]
        """
        // our native (JSON) data
        if let jsonData = jsonString.data(using: .utf8)
        {
            let decoder = JSONDecoder()
            
            do {
                // decoding our data
                let formModel = try decoder.decode([GetFormModel].self, from: jsonData)
                formModel.forEach { print($0) }
                //Encode data
                let jsonData = try! JSONEncoder().encode(formModel)
                let encodeJsonString = String(data: jsonData, encoding: .utf8)!
                print(encodeJsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func makeApiCall() {
        let urlStr = "https://jsonplaceholder.typicode.com/todos"
        guard let url = URL(string: urlStr) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode([User].self, from:
                    dataResponse) //Decode JSON Response Data
                print("models == \(model.map({$0}))")
                print("model id == \(model.map( { $0.userId } ))")
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    private func setupCollectionView() {
        xibCellsToRegister.forEach {
            //Register all cells
            let name = String(describing: $0)
            self.formListCollectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        }
    }
    private func initialSectionSetup() {
        //Set up sections
        if sections.count == 0 {
            let numberOfSection: Int = 1
            for index in 1...numberOfSection {
                var section = Section()
                section.sectionTitle = sectionTitles[index - 1]
                section.cellsIdentifier = []
                sections.append(section)
            }
            var section = Section()
            section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
            sections[0] = section
            return
        }
    }
    private func dynamicInitialSectionSetup() {
        //Set up sections
        if sections.count == 0 {
            let numberOfSection: Int = sectionTitles.count
            for index in 1...numberOfSection {
                var section = Section()
                section.sectionTitle = sectionTitles[index - 1]
                section.cellsIdentifier = []
                sections.append(section)
            }
            var section = Section()
            section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
            for i in 0..<numberOfSection {
                sections[i] = section
            }
            return
        }
    }
    @IBAction func uploadUserDetails(_ sender: Any) {
        self.view.endEditing(true)
       let model = GetFormModel(firstName: self.firstName, lastName: self.lastName)
        //Encode data
        let jsonData = try! JSONEncoder().encode(model)
        let encodeJsonString = String(data: jsonData, encoding: .utf8)!
        print(encodeJsonString)
        DispatchQueue.main.async {
            self.viewLoader.startAnimating(withUserInteration: false)
            let myURL = URL(string: "http://77.68.84.237/HixService/EMIS.svc/FileUpload2")!
            let request = NSMutableURLRequest(url: myURL)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                print(response)
                DispatchQueue.main.async {
                    self.viewLoader.stopAnimating()
                    self.showUploadAlert()
                }
            }
            task.resume()
        }
    }
    private func showUploadAlert() {
        let alert = UIAlertController(title: "SSFormIOS",
                                      message: "Form is uploaded successfully.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
extension FormViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections[section].isExpanded || section == 0 else { return 0 }
        return sections.count // sections[section].cellsIdentifier.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier:
            sections[indexPath.section].cellsIdentifier[indexPath.section],
                                                  for: indexPath) // if we want to show individual no of rows of section then call sections[indexPath.section].cellsIdentifier[indexPath.item]
    }
}
extension FormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        // Configure the actual cell data to be dispalyed.
        configure(cell, forItemAt: indexPath, in: collectionView)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let identifier = sections[indexPath.section].cellsIdentifier[indexPath.item]
//        guard let metaObject = xibCellsToRegister.first(where: { identifier == String(describing: $0)}) else { return .zero }
//        guard let staticCellable = metaObject as? StaticCellable.Type else { return .zero }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    private func configure(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        (cell as? ContainerCollectionViewCell)?.width = collectionView.bounds.width
        switch cell {
        case let infoCell as FormListCollectionViewCell:
            switch indexPath.item {
            case 0:
                infoCell.nameLabel.text = "First Name"
                infoCell.nameField.placeholder = "Enter first name"
                infoCell.nameField.tag = 0
            case 1:
                infoCell.nameLabel.text = "Last Name"
                infoCell.nameField.placeholder = "Enter last name"
                infoCell.nameField.tag = 1
            case 2:
                infoCell.nameLabel.text = "Address"
                infoCell.nameField.placeholder = "Enter Address"
                infoCell.nameField.tag = 2
            default:
                infoCell.nameLabel.text = "Gender"
                infoCell.nameField.placeholder = "Enter Gender"
                infoCell.nameField.tag = 3
                break
            }
            if indexPath.item == 0 {
               
            } else {
                
            }
            infoCell.nameField.delegate = self
//            infoCell.lastNameField.delegate = self
           break
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}
extension FormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
             firstName = textField.text
        case 1:
            lastName = textField.text
        case 2:
            address = textField.text
        default:
            gender = textField.text
            break
        }
    }
}
