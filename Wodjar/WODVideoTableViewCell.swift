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
    
    @IBOutlet var videoWebView: UIWebView!

    
//    var player: XCDYouTubeVideoPlayerViewController?
    
    func populate(with videoId: String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoId)")
            else {
                return
        }
        videoWebView.allowsInlineMediaPlayback = true
        videoWebView.loadHTMLString("<iframe webkit-playsinline width=\"\(videoWebView.frame.width)\" height=\"\(videoWebView.frame.height)\" src=\"\(youtubeURL)?feature=player_detailpage&playsinline=1\" frameborder=\"0\"></iframe>", baseURL: nil)
    }
    
    func stopPlaying() {

    }
}
