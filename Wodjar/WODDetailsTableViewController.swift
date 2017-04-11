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
    
    // @Constants
    let fullImageSegueIdentifier = "ShowFullImageSegueIdentifier"
    let logResultSegueIdentifier = "LogResultSegueIdentifier"
    
    // @Injected
    var wod: Workout!
    
    // @Properties
    var cellsBeforeResult = 0
    var _cellTypesInOrder: [WODDetailsCellType]?
    var cellTypesInOrder: [WODDetailsCellType] {
        if _cellTypesInOrder != nil {
            return _cellTypesInOrder!
        }
        
        _cellTypesInOrder = [WODDetailsCellType]()
        
        if wod.imageUrl != nil {
            _cellTypesInOrder!.append(.imageCell)
            cellsBeforeResult += 1
        }
        
        if wod.history != nil {
            _cellTypesInOrder!.append(.historyCell)
            cellsBeforeResult += 1
        }
        
        if wod.wodDescription != nil {
            _cellTypesInOrder!.append(.descriptionCell)
            cellsBeforeResult += 1
        }
        
        if wod.videoId != nil {
            _cellTypesInOrder!.append(.videoCell)
            cellsBeforeResult += 1
        }
        
        _cellTypesInOrder!.append(.logResultCell)
        cellsBeforeResult += 1
        
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
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        navigationItem.title = wod.name!
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapImage(_ sender: Any) {
        performSegue(withIdentifier: fullImageSegueIdentifier, sender: self)
    }

    @IBAction func didTapLogResultButton(_ sender: Any) {
        performSegue(withIdentifier: logResultSegueIdentifier, sender: self)
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
        
        populate(cell: cell, for: cellType, at: indexPath.row)
        
        return cell
    }
    
    // MARK: - Helper Methods
    
    func populate(cell: UITableViewCell, for type: WODDetailsCellType, at index: Int) {
        switch type {
        case .imageCell:
            (cell as! WODImageTableViewCell).populate(with: wod.imageUrl!)
        case .descriptionCell:
            (cell as! WODDescriptionTableViewCell).populate(with: wod.wodDescription!)
        case .videoCell:
            (cell as! WODVideoTableViewCell).populate(with: wod.videoId!)
        case .previousResultCell:
            (cell as! WODResultTableViewCell).populate(with: wod.results![index - cellsBeforeResult])
        case .historyCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        case .deleteCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == fullImageSegueIdentifier {
            let imageViewController = segue.destination as! FullSizeImageViewController
            imageViewController.imageUrl = wod.imageUrl!
        } else if identifier == logResultSegueIdentifier {
            let resultViewController = segue.destination as! WODResultViewController
            resultViewController.result = WODResult()
            resultViewController.controllerMode = .createMode
            resultViewController.service = WODResultService(remote: WODResultRemoteServiceTest())
            resultViewController.wod = wod
        }
    }
    
}
