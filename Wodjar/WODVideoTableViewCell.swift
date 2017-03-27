//
//  WODVideoTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class WODVideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoView: UIView!
    
    func populate(with videoId: String) {
        let youtubeController = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: videoId)
        youtubeController.present(in: videoView)
        youtubeController.moviePlayer.shouldAutoplay = false
        youtubeController.moviePlayer.prepareToPlay()
    }
}
