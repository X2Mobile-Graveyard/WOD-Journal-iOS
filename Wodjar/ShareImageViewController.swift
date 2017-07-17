//
//  ShareImageViewController.swift
//  WodJournal
//
//  Created by Bogdan Costea on 7/17/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import UIImageViewAlignedSwift

class ShareImageViewController: UIViewController {
    
    // @Injected
    var image: UIImage!
    var goBackViewController: UIViewController!
    
    // @IBOutlet
    @IBOutlet var shareImageView: UIImageViewAligned!
    
    
    // @Constants
    let fullImageSegueIdentifier = "goToFullImageViewer"
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        shareImageView.image = image
    }
    
    // MARK: - Buttons Actions
    @IBAction func didTapShareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSkipButton(_ sender: Any) {
        navigationController?.popToViewController(goBackViewController, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == fullImageSegueIdentifier {
            if let fullImageViewController = segue.destination as? FullSizeImageViewController {
                fullImageViewController.image = image
            }
        }
    }
}
