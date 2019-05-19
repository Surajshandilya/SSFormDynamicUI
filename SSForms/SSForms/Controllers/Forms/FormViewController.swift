//
//  FormViewController.swift
//  SSForms
//
//  Created by Suraj on 5/3/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

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

    var sectionTitles: [String] = ["Resident's Name",
                                   "Nursing/Residential Home",
                                   "Lead GP or Cluster Lead",
                                   "Date of Assesment",
                                   "Mental State Assessment? MMSE",
                                   "Mini Geriatric Depression Score or 6CIT",
                                   "Current Medical Problems",
                                   "Systems Review - problems identified",
                                   "Examination findings:",
                                   "Specific Additional Areas"]
    private var xibCellsToRegister: [UICollectionViewCell.Type] {
        return [FormListCollectionViewCell.self,
                    FormSelectiveOptionViewCell.self,
                    FormPopUpSelectionViewCell.self]
    }
    var sections: [Section] = []
    private let personalDetail: [String] = ["First Name",
                                                                  "Last Name",
                                                                  "D.O.B",
                                                                  "Gender"]
    private let personalDetailPlaceholder: [String] = ["Enter First Name",
                                            "Enter Last Name",
                                            "Enter D.O.B (MM/DD/YYYY)"]
    private let addressDetail: [String] = ["Flat No",
                                            "Street",
                                            "Zip Code"]
    private let addressDetailPlaceholder: [String] = ["Enter Flat Number",
                                                       "Enter Street",
                                                       "Enter Zip Code"]
    var firstName: String?
    var lastName: String?
    var address: String?
    var gender: String?
    var getFormModels = [GetFormModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
//        fetchJsonDataFromFile()
        initialSectionSetup()
    }
    private func fetchJsonDataFromFile() {
        //Check jsonObject is valid or not
        //        let valid = JSONSerialization.isValidJSONObject(jsonObject) // tru
        //        print("is valid json: \(valid)")
        guard let url = Bundle.main.url(forResource: "careForm", withExtension: "json") else { return }
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
    }
   private func readJSONObject(object: [String: AnyObject]) {
        guard let medicalForm = object["medical_form"] else { return }
        guard let outerSect = medicalForm["sections"] else { return }
        guard let obje = outerSect else { return }
//        for i in 1..<residentInfo.count {
//            let str = ""
//            sectionTitles.append(str)
//        }
//        print("all models: \(getFormModels)")
        //Update first sectionTitle
        dynamicInitialSectionSetup()
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
        self.formListCollectionView.register(UINib(nibName: "FormListHeaderReusableView",
                                                         bundle: nil),
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                   withReuseIdentifier: "FormListHeaderReusableView")
        self.formListCollectionView.register(UINib(nibName: "FormListBottomReusableView",
                                                   bundle: nil),
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                             withReuseIdentifier: "FormListBottomReusableView")
    }
    private func initialSectionSetup() {
        //Set up sections
        if sections.count == 0 {
            let numberOfSection: Int = sectionTitles.count
            for index in 1...numberOfSection {
                var section = Section()
                section.sectionTitle = sectionTitles[index - 1]
                section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
                sections.append(section)
            }
            //Load all cells data
            loadPersonalDetailSection()
            loadAddressSection()
            loadLeadGpOrClusterSection()
            loadDateOfAssesmentSection()
            loadMentalStateMMSESection()
            loadMiniGeriatricDepressionSection()
            loadCurrentMedicalProblemSection()
            loadSystemReviewProblemSection()
            loadExaminationFindingsSection()
            loadSpecificAdditinalAreaSection()
            return
        }
    }
    func loadPersonalDetailSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[0]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier,
                                                FormListCollectionViewCell.reuseIdentifier,
                                                FormListCollectionViewCell.reuseIdentifier,
                                                FormSelectiveOptionViewCell.reuseIdentifier]
        sections[0] = section
    }
    func loadAddressSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[1]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier,
                                   FormListCollectionViewCell.reuseIdentifier,
                                   FormListCollectionViewCell.reuseIdentifier]
        sections[1] = section
    }
    func loadLeadGpOrClusterSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[2]
        section.cellsIdentifier = [FormPopUpSelectionViewCell.reuseIdentifier]
        sections[2] = section
    }
    func loadDateOfAssesmentSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[3]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
        sections[3] = section
    }
    func loadMentalStateMMSESection() {
        var section = Section()
        section.sectionTitle = sectionTitles[4]
        section.cellsIdentifier = [FormSelectiveOptionViewCell.reuseIdentifier]
        sections[4] = section
    }
    func loadMiniGeriatricDepressionSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[5]
        section.cellsIdentifier = [FormSelectiveOptionViewCell.reuseIdentifier]
        sections[5] = section
    }
    func loadCurrentMedicalProblemSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[6]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
        sections[6] = section
    }
    func loadSystemReviewProblemSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[7]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
        sections[7] = section
    }
    func loadExaminationFindingsSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[8]
        section.cellsIdentifier = [FormListCollectionViewCell.reuseIdentifier]
        sections[8] = section
    }
    func loadSpecificAdditinalAreaSection() {
        var section = Section()
        section.sectionTitle = sectionTitles[9]
        section.cellsIdentifier = [FormSelectiveOptionViewCell.reuseIdentifier,
                                                FormSelectiveOptionViewCell.reuseIdentifier,
                                                FormPopUpSelectionViewCell.reuseIdentifier]
        sections[9] = section
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
            let str = "filename_\(self.getCurrentDateWithTime())"
            let params: [String: Any] = ["filename": str, "filesize": jsonData.count
            ]
            let searialStr = try! JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = searialStr
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
    private func getCurrentDateWithTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: Date())
    }
    private func showUploadAlert() {
        let alert = UIAlertController(title: "SSFormIOS",
                                      message: "Form is uploaded successfully.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (buttonAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
extension FormViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections[section].isExpanded else { return 0 } // || section == 0 if you want to bydefault expand section 0
        return sections[section].cellsIdentifier.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier:
            sections[indexPath.section].cellsIdentifier[indexPath.item],
                                                  for: indexPath) // if we want to show individual no of rows of section then call sections[indexPath.section].cellsIdentifier[indexPath.item]
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "FormListBottomReusableView",
                                                                               for: indexPath)
            guard let footerView = reusableView as? FormListBottomReusableView else { return UICollectionReusableView() }
            return footerView
        }
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "FormListHeaderReusableView",
                                                                           for: indexPath)
        guard let headerView = reusableView as? FormListHeaderReusableView else { return UICollectionReusableView() }
        headerView.subviews.forEach { $0.isHidden = false }
        //It will hide header at section 0.
//        indexPath.section == 0 ? headerView.subviews.forEach { $0.isHidden = false } : ()
        headerView.delegate = self as? FormListHeaderReusableViewDelegate
        headerView.sectionHeaderLabel.text = sections[indexPath.section].sectionTitle
        headerView.toggleExpandCollapseButton.tag = indexPath.section
        headerView.toogleHeaderButton.tag = indexPath.section
        headerView.toggleExpandCollapseButton.setTitle("+", for: .normal)
        sections[indexPath.section].isExpanded ? headerView.toggleExpandCollapseButton.setTitle("-", for: .normal) : ()
//        indexPath.section == 2 ? (headerView.toogleHeaderButton.isEnabled = false) : (headerView.toogleHeaderButton.isEnabled = true)
        return headerView
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
        let identifier = sections[indexPath.section].cellsIdentifier[indexPath.item]
        guard let metaObject = xibCellsToRegister.first(where: { identifier == String(describing: $0)}) else { return .zero }
        guard let staticCellable = metaObject as? StaticCellable.Type else { return .zero }
        return CGSize(width: collectionView.frame.width, height: staticCellable.totalCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: section == 0 ? 45.0 : 45.0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: section == 0 ? 1.0 : 1.0)
    }
    private func configure(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        (cell as? ContainerCollectionViewCell)?.width = collectionView.bounds.width
        switch cell {
        case let infoCell as FormListCollectionViewCell:
            var name = ""
            var placeHolder = ""
            var fieldTag = 0
            switch indexPath.section {
            case 0:
                name = personalDetail[indexPath.item]
                placeHolder = personalDetailPlaceholder[indexPath.item]
                fieldTag = indexPath.item //Need to pass correct
            case 1:
                name = addressDetail[indexPath.item]
                placeHolder = addressDetailPlaceholder[indexPath.item]
                fieldTag = indexPath.item //Need to pass correct
            case 3:
                name = "Date of Assesment"
                placeHolder = "Enter Assesment Date (MM/DD/YY)"
                fieldTag = indexPath.item //Need to pass correct
            case 6:
                name = "Current Medical Problems"
                placeHolder = ""
                fieldTag = indexPath.item //Need to pass correct
            case 7:
                name = "Systems Review - problems"
                placeHolder = ""
                fieldTag = indexPath.item //Need to pass correct
            case 8:
                name = "Examination findings"
                placeHolder = ""
                fieldTag = indexPath.item //Need to pass correct
            default:
                name = "Gender"
                placeHolder = "Enter Gender"
                fieldTag = 3
                break
            }// This swicth for section case
            infoCell.nameLabel.text = name
            infoCell.nameField.placeholder = placeHolder
            infoCell.nameField.tag = fieldTag
            infoCell.nameField.delegate = self
            break
            case let selectiveOptionCell as FormSelectiveOptionViewCell:
                var title = ""
                var firstOptionTitle = ""
                var secondOptionTitle = ""
                switch(indexPath.section) {
                case 0:
                    title = "Gender"
                    firstOptionTitle = "Male"
                    secondOptionTitle = "Female"
                case 4:
                    title = "MMSE"
                    firstOptionTitle = "Yes"
                    secondOptionTitle = "No"
                case 5:
                    title = "Mini Geriatric Depression Score"
                    firstOptionTitle = "Yes"
                    secondOptionTitle = "No"
                case 9:
                    switch indexPath.item {
                    case 0:
                        title = "Mobility"
                        firstOptionTitle = "Bedbound"
                        secondOptionTitle = "Stick or zimmer"
                    case 1:
                        title = "     "
                        firstOptionTitle = "Wheelchair"
                        secondOptionTitle = "Unaided"
                    default:
                        break
                    }
                    
                    break
                default:
                    break
            }
                selectiveOptionCell.titleLable.text = title
                selectiveOptionCell.firstOptionLabel.text = firstOptionTitle
                selectiveOptionCell.secondOptionLabel.text = secondOptionTitle
        case let popUpSelectionCell as FormPopUpSelectionViewCell:
            break
        default:
            break
        }//Outer Swicth for Cell
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
extension FormViewController: FormListHeaderReusableViewDelegate {
    func toggleBtnTapped(_ headerView: FormListHeaderReusableView, didTapToggleButton button: UIButton) {
        var sectionsToReload = [button.tag]
        for (index, section) in sections.enumerated() {
            guard section.isExpanded, index != button.tag else { continue }
            sectionsToReload.append(index)
            var mutableSection = section
            mutableSection.isExpanded = false
            sections[index] = mutableSection
        }
        var section = sections[button.tag]
        section.isExpanded = !section.isExpanded
        sections[button.tag] = section
        self.formListCollectionView.performBatchUpdates({
            formListCollectionView.reloadSections(IndexSet(sectionsToReload))
        }, completion: nil)
    }
}
