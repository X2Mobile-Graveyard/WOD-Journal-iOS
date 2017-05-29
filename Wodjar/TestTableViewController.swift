//
//  TestTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 5/17/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage

class TestTableViewController: UITableViewController {

    var imageView: UIImageView!
    var cachedImageViewSize: CGRect!
    let imageOffset: CGFloat = -10.0
    let topBarHeight: CGFloat = 20
    let headerHeight: CGFloat = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.imageView = UIImageView()
//        self.imageView.sd_setImage(with: URL(string: "https://lh4.ggpht.com/wKrDLLmmxjfRG2-E-k5L5BUuHWpCOe4lWRF7oVs1Gzdn5e5yvr8fj-ORTlBF43U47yI=w300"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
//        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 170)
//        self.imageView.contentMode = .center
//        self.cachedImageViewSize = self.imageView.frame
//        self.tableView.addSubview(self.imageView)
//        self.imageView.center = CGPoint(x: self.view.center.x, y: self.imageView.center.y)
//        self.tableView.sendSubview(toBack: self.imageView)
//        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 170))
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        let blackBorderView = UIView(frame: CGRect(x: 0, y: headerHeight - 1, width: view.frame.size.width, height: 1.0))
        blackBorderView.backgroundColor = .black
        headerView.addSubview(blackBorderView)
        
        tableView.tableHeaderView = headerView
        
        imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: "https://www.intelligentlabs.org/wp-content/uploads/2016/04/5-defining-moments-of-murph-the-most-brutal-crossfit-hero-wod-01.jpg"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight)
        var headerImageFrame = imageView.frame
        headerImageFrame.origin.y = imageOffset
        imageView.frame = headerImageFrame
        view.insertSubview(imageView, belowSubview: tableView)
        cachedImageViewSize = imageView.frame
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // this is just a demo method on how to compute the scale factor based on the current contentOffset
        var scale = 1.0 + fabsf(Float(scrollView.contentOffset.y))  / Float(scrollView.frame.size.height);
        
        //Cap the scaling between zero and 1
        scale = max(0.0, scale)
        imageView.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        
        // Set the scale to the imageView
//        imageView.transform = CGAffineTransformMakeScale(scale, scale);
//        let scrollOffset = scrollView.contentOffset.y
//        if scrollOffset > (imageOffset - topBarHeight) {
//            translateImage(with: scrollOffset)
//        } else {
//            zoomImage(with: -scrollOffset)
//        }
//        
    }
    
    func translateImage(with scrollOffset: CGFloat) {
        var imageFrame = imageView.frame
        
        print(scrollOffset)
        
        if scrollOffset < 0 {
            imageFrame.origin.y = imageOffset - (scrollOffset / 3)
        } else {
            imageFrame.origin.y = imageOffset - scrollOffset
        }
        
        imageView.frame = imageFrame
    }
    
    func zoomImage(with scrollOffset: CGFloat) {
        if scrollOffset > 0 {
            imageView.frame = CGRect(x: 0,
                                 y: -scrollOffset,
                                 width: cachedImageViewSize.size.width + scrollOffset,
                                 height: cachedImageViewSize.size.height + scrollOffset)
            
        } else {
            imageView.frame = CGRect(x: 0,
                                     y: -scrollOffset,
                                     width: cachedImageViewSize.size.width + scrollOffset,
                                     height: cachedImageViewSize.size.height + scrollOffset)
        }
        
        imageView.center = CGPoint(x: view.center.x, y: imageView.center.y)
    }

}
