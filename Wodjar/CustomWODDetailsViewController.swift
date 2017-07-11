//
//  CustomWODDetailsViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

protocol CustomWodUpdateDelegate {
    func didDelete(wod: Workout)
}

class CustomWODDetailsViewController: WODDetailsTableViewController {
    
    // @Properties
    var wodCopy: Workout!
    
    // @Injected
    var delegate : CustomWodUpdateDelegate?
    var service: WODService!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wodCopy = Workout(using: wod)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(didTapEditButton(_:)))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            removeImageFromCache(localOnly: true)
            wodCopy.results = wod.results
            wod.updateValues(from: wodCopy)
        }
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapChangePhotoButton(_ sender: Any) {
        removeImageFromCache(localOnly: false)
        presentAlertControllerForEditingPicture()
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        wodCopy.results = wod.results
        MBProgressHUD.showAdded(to: view, animated: true)
        service.update(wodCopy: wodCopy, with: wod) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success():
                self.wodCopy.updateValues(from: self.wod)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    @IBAction func didTapAddImageButton(_ sender: Any) {
        removeImageFromCache(localOnly: false)
        presentAlertControllerForTakingPicture()
    }

    @IBAction func didTapDeleteWodButton(_ sender: Any) {
        showDeleteAlert(with: "Warning",
                        message: "This action will permanently delete this wod. Are you sure?",
                        actionButtonTitle: "Delete") { (_) in
                            self.deleteWod()
        }
    }
    
    func didTapEditButton(_ sender: Any) {
        canEdit = true
        _cellTypesInOrder = nil
        tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSaveButton(_:)))

    }
    
    // MARK: - Service Calls
    
    func deleteWod() {
        MBProgressHUD.showAdded(to: view, animated: true)
        service.deleteWod(with: wod.id) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success(_):
                if self.delegate != nil {
                    self.delegate?.didDelete(wod: self.wod)
                }
                self.navigationController?.popViewController(animated: true)
            case .failure(_):
                self.handleError(result: result)
            }
        }
    }
    
    // MARK: - Alert Controllers
    
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
    
    // MARK: - HelperMethods
    
    func removeImage() {
        wod.imageUrl = nil
        _cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    func setImage(from localPath: String) {
        wod.imageUrl = localPath
        _cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    func removeImageFromCache(localOnly: Bool) {
        if wod.imageUrl != nil {
            var url: URL
            if wod.imageUrl!.isLocalFileUrl() {
                url = URL(fileURLWithPath: wod.imageUrl!)
                SDImageCache.shared().removeImage(forKey:url.absoluteString, withCompletion: nil)
            } else if !localOnly {
                if let url = URL(string: wod.imageUrl!) {
                    SDImageCache.shared().removeImage(forKey:url.absoluteString, withCompletion: nil)
                }
            }
        }
    }
}

extension CustomWODDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        wod.wodDescription = textView.text
    }
}

extension CustomWODDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        setImage(from: localPath)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
