//
//  FullSizeImageViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/6/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class FullSizeImageViewController: UIViewController {

    // @IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // @Injected
    var imageUrl: String?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageUrl != nil {
            if imageUrl!.isLocalFileUrl() {
                imageView.sd_setImage(with: URL(fileURLWithPath: imageUrl!))
            } else {
                imageView.sd_setImage(with: URL(string: imageUrl!))
            }
        } else {
            imageView.image = image
        }
        
        setZoomScale()
        setupGestureRecognizer()
    }

    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    
    func setupGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTap)
        
        singleTap.require(toFail: doubleTap)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    // MARK: - Orientation
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
}

extension FullSizeImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
