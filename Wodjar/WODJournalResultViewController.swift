//
//  WODJournalResultViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/11/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODJournalResultViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var userPictureView: UIView!
    @IBOutlet var footerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var changePictureBackgroundView: UIView!
    
    // @Properties
    var userImage: UIImage?
    var viewState: ViewControllerState = .withoutImage
    var pickedImagePath: String?
    var pickedImageCompletion: (()->Void)?
    
    
    // @Constants
    let viewInset: CGFloat = 16
    let imageRatio: CGFloat = 0.75
    
    // ImagePicker + Modal Presentation
    
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
            self.removeUserImage()
        }
        alertController.addAction(deleteAction)
        
        return alertController
    }
    
    // MARK: - Image Handle Methods
    
    func removeUserImage() {
        pickedImagePath = nil
        userPictureView.removeFromSuperview()
        footerViewBottomConstraint.isActive = true
        viewState = .withoutImage
        addPictureButton.isHidden = false
    }
    
    func setUserImage() {
        guard let image = userImage else {
            return
        }
        
        imageView.image = image
        
        if viewState == .withImage {
            return
        }
        
        addUserPictureToView()
        
        viewState = .withImage
        
        addPictureButton.isHidden = true
    }
    
    func addUserPictureToView() {
        contentView.addSubview(userPictureView)
        footerViewBottomConstraint.isActive = false
        addConstrainsForPictureView()
    }
    
    func addConstrainsForPictureView() {
        userPictureView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidth = view.bounds.size.width - 2 * viewInset
        let imageHeight = imageWidth * imageRatio
        
        
        let leading = NSLayoutConstraint(item: userPictureView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: contentView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: viewInset)
        
        let trailing = NSLayoutConstraint(item: userPictureView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: contentView,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: -viewInset)
        
        let height = NSLayoutConstraint(item: userPictureView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: imageHeight)
        
        let top = NSLayoutConstraint(item: userPictureView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: footerView,
                                     attribute: .bottom,
                                     multiplier: 1,
                                     constant: 8)
        
        let bottom = NSLayoutConstraint(item: userPictureView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: deleteButton,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: -20)
        
        view.addConstraints([leading, trailing, height, top, bottom])
    }

    
}

extension WODJournalResultViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let imageName = "example"
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName)
        
        let data = UIImageJPEGRepresentation(image, 1.0)
        try? data?.write(to: URL(fileURLWithPath: localPath))
        
        pickedImagePath = localPath
        
        userImage = image
        if pickedImageCompletion != nil {
            dismiss(animated: true, completion: pickedImageCompletion)
            return
        }
        
        setUserImage()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
