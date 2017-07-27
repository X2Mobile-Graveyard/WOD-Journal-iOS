//
//  WODDetailsTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import FacebookShare

enum WODDetailsCellType: String {
    case imageCell = "WodPictureCell"
    case historyCell = "HeroHistoryCell"
    case descriptionCell = "WodDescriptionCell"
    case videoCell = "WodVideoCell"
    case logResultCell = "AddResultCell"
    case previousResultCell = "WodResultCell"
    case deleteCell = "DeleteCell"
    case addImageCell = "AddImageCell"
    case pastRsultCell = "ResultsLabelCell"
}

protocol WodResultDelegate {
    func didCreate(result: WODResult)
    func didDelete(result: WODResult)
    func didUpdate()
}

class WODDetailsTableViewController: UITableViewController {
    
    // @Constants
    let fullImageSegueIdentifier = "ShowFullImageSegueIdentifier"
    let logResultSegueIdentifier = "LogResultSegueIdentifier"
    let historySegueIdentifier = "ShowHistorySegueIdentifier"
    let editResultSegueIdentifier = "EditResultSegueIdentifier"
    
    // @Injected
    var wod: Workout!
    var resultService: WODResultService!
    
    // @Properties
    var canEdit = false
    var showPrevResultsLabel = false
    var fetchingResults = true
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
        } else if wod.type == .custom && canEdit {
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
        
        if showPrevResultsLabel {
            _cellTypesInOrder!.append(.pastRsultCell)
            cellsBeforeResult += 1
        }
        
        if wod.results != nil && wod.results!.count > 0 {
            _cellTypesInOrder!.append(contentsOf: Array(repeating: .previousResultCell, count: wod.results!.count))
        }
        
        if wod.type == .custom && canEdit {
            _cellTypesInOrder!.append(.deleteCell)
        }
        
        return _cellTypesInOrder!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        navigationItem.title = wod.name ?? "Custom WOD"
        populateResults()
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
                self.resetViewControllers()
            })
            return
        }
        performSegue(withIdentifier: logResultSegueIdentifier, sender: self)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellType = cellTypesInOrder[indexPath.row]
        if cellType != .previousResultCell {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexToDelete = indexPath.row - cellsBeforeResult;
            if let deletedResult = handleResultDelete(at: indexToDelete) {
                delete(wodResult: deletedResult)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            
            if wod.results?.count == 0 {
                showPrevResultsLabel = false
                _cellTypesInOrder = nil
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cellTypesInOrder[indexPath.row]
        if cellType != .previousResultCell {
            return
        }
        
        selectedResult = wod.results?[indexPath.row - cellsBeforeResult]
        performSegue(withIdentifier: editResultSegueIdentifier, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? WODVideoTableViewCell {
            videoCell.stopPlaying()
        }
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
    
    func populateResults() {
        if wod.results != nil {
            self.addResultToTable()
            return
        }
        
        addSpinnerForResults()
        getResults()
    }
    
    func addSpinnerForResults() {
        if fetchingResults {
            let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
            tableView.tableFooterView = spinner
        }
    }
    
    func getResults() {
        resultService.getResult(for: wod) { (result) in
            self.fetchingResults = false
            self.tableView.tableFooterView = UIView()
            switch result {
            case let .success(results):
                self.wod.results = results
                self.wod.orderResults()
                self.addResultToTable()
            case .failure(_):
                break
            }
        }
    }
    
    func addResultToTable() {
        if wod.results!.count > 0 {
            showPrevResultsLabel = true
        } else {
            showPrevResultsLabel = false
        }
        _cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    func populate(cell: UITableViewCell, for type: WODDetailsCellType, at index: Int) {
        cell.selectionStyle = .none
        switch type {
        case .imageCell:
            (cell as! WODImageTableViewCell).populate(with: wod.imageUrl!, editType: canEdit)
        case .descriptionCell:
            var toolBar: UIToolbar? = nil
            if wod.type == .custom && canEdit {
                toolBar = createKeyboardToolbar(with: "Done", selector: #selector(didChangeDescription))
            }
            (cell as! WODDescriptionTableViewCell).populate(with: wod,
                                                            for: wod.type!,
                                                            editMode: canEdit,
                                                            toolbar: toolBar)
        case .videoCell:
            (cell as! WODVideoTableViewCell).populate(with: wod.videoId!)
        case .previousResultCell:
            cell.selectionStyle = .default
            (cell as! WODResultTableViewCell).populate(with: wod.results![index - cellsBeforeResult])
        default:
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }
    }
    
    func didChangeDescription() {
        view.endEditing(true)
    }
    
    func delete(wodResult: WODResult) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        resultService.delete(wodResult: wodResult, with: { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    func handleResultDelete(at indexToDelete: Int) -> WODResult? {
        let deletedResult = wod.results?[indexToDelete]
        self.wod.results?.remove(at: indexToDelete)
        self.wod.updateBestRecord()
        self._cellTypesInOrder = nil
        if wod.results?.count == 0 {
            wod.isCompleted = false
        }
        
        return deletedResult
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
            let newResult = WODResult()
            newResult.resultType = wod.category!
            resultViewController.result = newResult
            resultViewController.controllerMode = .createMode
            resultViewController.service = resultService
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
            resultViewController.service = resultService
            resultViewController.wod = wod
            resultViewController.wodResultDelegate = self
        default:
            break
        }
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage? {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Chalkduster", size: 25)!
        
        let textSize = text.size(attributes: [NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor])
        
        let size = CGSize(width: image.size.width, height: textSize.height + 50)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let rect = CGRect(origin: point, size: size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension WODDetailsTableViewController: WodResultDelegate {
    func didCreate(result: WODResult) {
        if wod.results?.count == 0 {
            wod.isCompleted = true
            showPrevResultsLabel = true
        }
        wod.initBestRecord(with: result)
        wod.results?.insert(result, at: 0)
        _cellTypesInOrder = nil
        tableView.reloadData()
    }
    
    func didDelete(result: WODResult) {
        if let indexToDelete = wod.results?.index(where: {$0.id! == result.id!}) {
            _ = handleResultDelete(at: indexToDelete)
            tableView.reloadData()
        }
    }
    
    func didUpdate() {
        wod.updateBestRecord()
        tableView.reloadData()
    }
}
