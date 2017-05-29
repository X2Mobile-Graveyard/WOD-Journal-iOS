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
        
        videoWebView.scrollView.isScrollEnabled = false
        videoWebView.scrollView.bounces = false
        videoWebView.allowsInlineMediaPlayback = true
        let embedHTML = "<html>" +
            "<body style='margin:0px;padding:0px;'>" +
            "<script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>" +
            "<script type='text/javascript'>" +
            "function onYouTubeIframeAPIReady()" +
            "{" +
            "    ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})" +
            "}" +
            "</script>" +
            "   <iframe id='playerId' type='text/html' width='100%%\(videoWebView.frame.width)' height='100%%\(videoWebView.frame.height)' src='\(youtubeURL)?enablejsapi=1&rel=0&playsinline=1' frameborder='0'>" +
            "        </body>" +
        "</html>"
        videoWebView.loadHTMLString(embedHTML, baseURL:Bundle.main.resourceURL!)
    }
    
    func stopPlaying() {

    }
}
