//
//  DefaultWODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class DefaultWODTypeTableViewController: WODTypeTableViewController {

    // @Constants
    let defaultWodDetailsSegueIdentifier = "DefaultWodDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWOD = workouts[indexPath.row]
        performSegue(withIdentifier: defaultWodDetailsSegueIdentifier, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedWOD?.set(description: "asfklkgagasdgj;", image: "https://pbs.twimg.com/profile_images/2449186867/549619_348620965213858_1616045858_n.jpeg", history: "asfasgags", category: .amrap, video: "9bZkp7q19f0", unit: .metric)
        selectedWOD?.results = [WODResult(), WODResult(), WODResult(), WODResult()]
        
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == defaultWodDetailsSegueIdentifier {
            let defaultWodDetailsVC = segue.destination as! DefaultWODDetailsViewController
            defaultWodDetailsVC.wod = selectedWOD
        }
    }
}
