//
//  MoreTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/18/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import RSKImageCropper
import MBProgressHUD

enum MoreTableViewCellType: String {
    case simpleCell = "SimpleTextCell"
    case unitsCell = "UnitSystemCell"
    case userProfileCell = "UserInfoCell"
}

protocol UpdateUserDelegate {
    func updateUser(with name: String?)
}

class MoreTableViewController: UITableViewController {
    
    // @Injected
    var service: UserService!

    // @Properties
    var _cellTypesInOrder: [MoreTableViewCellType]?
    var cellHeightsInOrder: [CGFloat]?
    var cellTypesInOrder: [MoreTableViewCellType] {
        if _cellTypesInOrder != nil {
            return _cellTypesInOrder!
        }
        
         _cellTypesInOrder = [MoreTableViewCellType]()
        cellHeightsInOrder = [CGFloat]()
        
        if UserManager.sharedInstance.isAuthenticated() {
            _cellTypesInOrder?.append(.userProfileCell)
            cellHeightsInOrder?.append(133)
        } else {
            _cellTypesInOrder?.append(.simpleCell)
            cellHeightsInOrder?.append(44)
        }
        
        _cellTypesInOrder?.append(.unitsCell)
        cellHeightsInOrder?.append(64)
        _cellTypesInOrder?.append(.simpleCell)
        cellHeightsInOrder?.append(44)

        return _cellTypesInOrder!
    }
    var imageUrl: String?

    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserManager.sharedInstance.isAuthenticated() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapLogoutButton(_:)))
        }
        _cellTypesInOrder = nil
        tableView.reloadData()

    }

    // MARK: - Actions
    
    @IBAction func didChangeUnitsType(_ sender: Any) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        
        if UserManager.sharedInstance.isAuthenticated() {
            UserManager.sharedInstance.unitType = UnitType(rawValue: index)!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UnitType"), object: nil)
        }
    }
    
    @IBAction func didTapUserPicture(_ sender: Any) {
        if UserManager.sharedInstance.isAuthenticated() && UserManager.sharedInstance.imageUrl != nil {
            presentAlertControllerForEditingPicture()
            return
        }
        
        presentAlertControllerForTakingPicture()
    }
    
    func didTapLogoutButton(_ sender: Any) {
        signOut()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypesInOrder.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTypesInOrder[indexPath.section].rawValue, for: indexPath)
        
        cell.selectionStyle = .none
        
        switch cellTypesInOrder[indexPath.section] {
        case .simpleCell:
            cell.selectionStyle = .default
            (cell as! MoreSimpleTextTableViewCell).populate(with: indexPath.section == 0 ? "Login" : "Feedback")
        case .userProfileCell:
            (cell as! MoreUserProfileTableViewCell).populateCell()
            (cell as! MoreUserProfileTableViewCell).delegate = self
        case .unitsCell:
            (cell as! MoreUnitTypeTableViewCell).populate()
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 15
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellTypesInOrder[indexPath.section] != .simpleCell {
            return
        }
        
        if indexPath.section == 0 {
            showLogin {
                self.didLogin()
            }
        } else {
            sendMail()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightsInOrder![indexPath.section]
    }
    
    // MARK: - Edit Photo Methods
    
    func presentAlertControllerForTakingPicture() {
        let alertController = createAlertControllerForTakePhoto()
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertControllerForEditingPicture() {
        let alertController = createAlertControllerForEditPhoto()
        present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePickerFor(type: UIImagePickerControllerSourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            showError(with: "Option not available on this device")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    func createAlertControllerForTakePhoto(anotherString: String = "") -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePictureAction = UIAlertAction(title: "Take \(anotherString)Photo", style: .default) { (action) in
            self.presentImagePickerFor(type: .camera)
        }
        alertController.addAction(takePictureAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose \(anotherString)Photo", style: .default) { (action) in
            self.presentImagePickerFor(type: .photoLibrary)
        }
        alertController.addAction(chooseFromLibraryAction)
        
        return alertController
    }
    
    func createAlertControllerForEditPhoto() -> UIAlertController {
        let alertController = createAlertControllerForTakePhoto(anotherString: "Another ")
        
        let deleteAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            self.removeImage()
        }
        alertController.addAction(deleteAction)
        
        return alertController
    }

    
    // MARK: - Helper Methods
    
    private func resetViewControllers() {
        for viewController in (tabBarController?.viewControllers)! {
            if let navController = viewController as? UINavigationController {
                if navController == navigationController {
                    continue
                }
                
                navController.popToRootViewController(animated: false)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Auth"), object: nil)
    }
    
    private func didLogin() {
        self.resetViewControllers()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapLogoutButton(_:)))
        self._cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    private func signOut() {
        UserManager.sharedInstance.signOut()
        SessionManager.sharedInstance.deleteAllUserDefaults()
        self.resetViewControllers()
        navigationItem.rightBarButtonItem = nil
        self._cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    func setImage(from localPath: String) {
        imageUrl = localPath
        updateUser(with: nil)
        
    }
    
    private func removeImage() {
        imageUrl = nil
        updateUser(with: nil)
    }
}

extension MoreTableViewController: UpdateUserDelegate {
    func updateUser(with name: String?) {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.updateUser(with: name ?? UserManager.sharedInstance.userName,
                           imageUrl: imageUrl) { (result) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            switch result {
                            case .success(_):
                                self.tableView.reloadData()
                            case .failure(_):
                                self.handleError(result: result)
                                self.tableView.reloadData()
                            }
        }
    }
}

extension MoreTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let imageName = "example.jpg"
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName)
        
        let data = UIImageJPEGRepresentation(image, 1.0)
        try? data?.write(to: URL(fileURLWithPath: localPath))
        
        dismiss(animated: true) { 
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
            
            imageCropVC.delegate = self
            
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MoreTableViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                 usingCropRect cropRect: CGRect) {
        let imageName = "example"
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName)
        
        let data = UIImagePNGRepresentation(croppedImage)
        try? data?.write(to: URL(fileURLWithPath: localPath))
        
        setImage(from: localPath)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
