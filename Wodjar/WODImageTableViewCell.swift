//
//  WODImageTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage
import UIImageViewAlignedSwift

class WODImageTableViewCell: UITableViewCell {

    @IBOutlet var wodImageView: UIImageViewAligned!
    @IBOutlet var changeImageView: UIView!
    
    func populate(with imageURL: String, editType: Bool) {
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        guard let url = URL(string: imageURL) else {
            return
        }
        
        if (editType) {
            changeImageView.isHidden = false
        } else {
            if changeImageView != nil {
                changeImageView.isHidden = true
            }
        }
        
        if imageURL.isLocalFileUrl() {
            wodImageView.sd_setImage(with:(URL(fileURLWithPath: imageURL)))
        } else {
            wodImageView.sd_setImage(with: url)
        }
    }
}
