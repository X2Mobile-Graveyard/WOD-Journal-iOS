//
//  WODDetailsTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

enum WODDetailsCellType: String {
    case imageCell = "WodPictureCell"
    case historyCell = "HeroHistoryCell"
    case descriptionCell = "WodDescriptionCell"
    case videoCell = "WodVideoCell"
    case logResultCell = "AddResultCell"
    case previousResultCell = "WodResultCell"
    case premiumCell = "GoPremiumCell"
    case deleteCell = "DeleteCell"
}

class WODDetailsTableViewController: UITableViewController {
    
    // @Injected
    var wod: Workout!
    
    // @Properties
    var _cellTypesInOrder: [WODDetailsCellType]?
    var cellTypesInOrder: [WODDetailsCellType] {
        if _cellTypesInOrder != nil {
            return _cellTypesInOrder!
        }
        
        _cellTypesInOrder = [WODDetailsCellType]()
        
        if wod.imageUrl != nil {
            _cellTypesInOrder!.append(.imageCell)
        }
        
        if wod.history != nil {
            _cellTypesInOrder!.append(.historyCell)
        }
        
        if wod.wodDescription != nil {
            _cellTypesInOrder!.append(.descriptionCell)
        }
        
        if wod.videoId != nil {
            _cellTypesInOrder!.append(.videoCell)
        }
        
        _cellTypesInOrder!.append(.logResultCell)
        
        if wod.results != nil {
            if wod.results!.count > 0 {
                _cellTypesInOrder!.append(contentsOf: Array(repeating: .previousResultCell, count: wod.results!.count))
            }
            
            if wod.results!.count > 2 {
                _cellTypesInOrder!.append(.premiumCell)
            }
            
        }
        
        if wod.type == .custom {
            _cellTypesInOrder!.append(.deleteCell)
        }
        
        return _cellTypesInOrder!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypesInOrder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypesInOrder[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)
        
        populate(cell: cell, for: cellType)
        
        return cell
    }
    
    // MARK: - Helper Methods
    
    func populate(cell: UITableViewCell, for type: WODDetailsCellType) {
        switch type {
        case .imageCell:
            (cell as! WODImageTableViewCell).populate(with: wod.imageUrl!)
        case .descriptionCell:
            (cell as! WODDescriptionTableViewCell).populate(with: wod.wodDescription!)
        case .videoCell:
            (cell as! WODVideoTableViewCell).populate(with: wod.videoId!)
        case .previousResultCell:
            (cell as! WODResultTableViewCell).populate(with: WODResult())
        default:
            break
        }
    }
    
}
