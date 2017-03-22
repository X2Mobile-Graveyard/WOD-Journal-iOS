//
//  MoreComponent.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class MoreComponent: IBControl {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var centerImageViewConstraintConstant: CGFloat = 0 {
        didSet {
            imageViewCenterConstraint.constant = centerImageViewConstraintConstant
        }
    }
    
    @IBInspectable var imageViewHeightConstraintConstant: CGFloat = 0 {
        didSet {
            imageViewHeightConstraint.constant = imageViewHeightConstraintConstant
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapMoreComponent(_ sender: Any) {
        sendActions(for: .touchUpInside)
    }
}
