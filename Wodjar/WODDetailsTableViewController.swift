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
    case addImageCell = "AddImageCell"
}

protocol WodResultDelegate {
    func didCreate(result: WODResult)
    func didDelete(result: WODResult)
}

class WODDetailsTableViewController: UITableViewController {
    
    // @Constants
    let fullImageSegueIdentifier = "ShowFullImageSegueIdentifier"
    let logResultSegueIdentifier = "LogResultSegueIdentifier"
    let historySegueIdentifier = "ShowHistorySegueIdentifier"
    let editResultSegueIdentifier = "EditResultSegueIdentifier"
    
    // @Injected
    var wod: Workout!
    
    // @Properties
    var selectedResult: WODResult?
    var cellsBeforeResult = 0
    var _cellTypesInOrder: [WODDetailsCellType]?
    var cellTypesInOrder: [WODDetailsCellType] {
        if _cellTypesInOrder != nil {
            return _cellTypesInOrder!
        }
        
        _cellTypesInOrder = [WODDetailsCellType]()
        cellsBeforeResult = 0
        
        if wod.imageUrl != nil {
            _cellTypesInOrder!.append(.imageCell)
            cellsBeforeResult += 1
        } else if wod.type == .custom {
            _cellTypesInOrder?.append(.addImageCell)
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
        
        if wod.results != nil && wod.results!.count > 0 {
            if wod.results!.count <= 3 {
                _cellTypesInOrder!.append(contentsOf: Array(repeating: .previousResultCell, count: wod.results!.count))
            } else {
                _cellTypesInOrder!.append(contentsOf: Array(repeating: .previousResultCell, count: 3))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func didTapImage(_ sender: Any) {
        performSegue(withIdentifier: fullImageSegueIdentifier, sender: self)
    }

    @IBAction func didTapLogResultButton(_ sender: Any) {
        if !UserManager.sharedInstance.isAuthenticated() {
            presentLoginScreen(with: { 
                self.returnToFirstScreen()
            })
            
            return
        }
        
        performSegue(withIdentifier: logResultSegueIdentifier, sender: self)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cellTypesInOrder[indexPath.row]
        if cellType != .previousResultCell {
            return
        }
        
        selectedResult = wod.results?[indexPath.row - cellsBeforeResult]
        performSegue(withIdentifier: editResultSegueIdentifier, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        cell.selectionStyle = .none
        switch type {
        case .imageCell:
            (cell as! WODImageTableViewCell).populate(with: wod.imageUrl!)
        case .descriptionCell:
            var toolBar: UIToolbar? = nil
            if wod.type == .custom {
                toolBar = createKeyboardToolbar(with: "Done", selector: #selector(didChangeDescription))
            }
            (cell as! WODDescriptionTableViewCell).populate(with: wod.wodDescription!, for: wod.type!, toolbar: toolBar)
        case .videoCell:
            (cell as! WODVideoTableViewCell).populate(with: wod.videoId!)
        case .previousResultCell:
            cell.selectionStyle = .default
            (cell as! WODResultTableViewCell).populate(with: wod.results![index - cellsBeforeResult])
        case .historyCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        case .deleteCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        case .addImageCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        case .logResultCell:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        default:
            break
        }
    }
    
    func didChangeDescription() {
        view.endEditing(true)
    }
    
    func returnToFirstScreen() {
        for controller in (navigationController?.viewControllers)! {
            if let typesController = controller as? WODTypesTableViewController {
                typesController.getWods()
                navigationController?.popToViewController(typesController, animated: true)
                return
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case fullImageSegueIdentifier:
            let imageViewController = segue.destination as! FullSizeImageViewController
            imageViewController.imageUrl = wod.imageUrl!
        case logResultSegueIdentifier:
            let resultViewController = segue.destination as! WODResultViewController
            resultViewController.result = WODResult()
            resultViewController.controllerMode = .createMode
            resultViewController.service = WODResultService(remote: WODResultRemoteServiceTest(), s3Remote: S3RemoteService())
            resultViewController.wod = wod
            resultViewController.wodResultDelegate = self
        case historySegueIdentifier:
            let historyViewController = segue.destination as! WODHistoryViewController
            historyViewController.historyText = wod.history
        case editResultSegueIdentifier:
            if selectedResult == nil {
                return
            }
            let resultViewController = segue.destination as! WODResultViewController
            resultViewController.result = selectedResult!
            resultViewController.controllerMode = .editMode
            resultViewController.service = WODResultService(remote: WODResultRemoteServiceTest(), s3Remote: S3RemoteService())
            resultViewController.wod = wod
            resultViewController.wodResultDelegate = self
        default:
            break
        }
    }
}

extension WODDetailsTableViewController: WodResultDelegate {
    func didCreate(result: WODResult) {
         wod.results?.append(result)
        _cellTypesInOrder = nil
    }
    
    func didDelete(result: WODResult) {
        if let indexToDelete = wod.results?.index(where: {$0.id! == result.id!}) {
            wod.results?.remove(at: indexToDelete)
            _cellTypesInOrder = nil
        }
    }
}
