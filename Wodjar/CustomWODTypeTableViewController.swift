//
//  CustomWODTypeTableViewController.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/21/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class CustomWODTypeTableViewController: WODTypeTableViewController {

    // @Constants
    let customWodDetailsSegueIdentifier = "CustomWodDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWOD = workouts[indexPath.row]
        performSegue(withIdentifier: customWodDetailsSegueIdentifier, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedWOD?.set(description: "asfklkgagasdgj;asdkjghshgdlksglhsdgheo;ihaeiovhiinvna;rvainevionaeoivnaenveairvihaervhierh[aerhf[e0jrj09rjf9jvj9rvj[rj9v90erjv[0e9hr0e9hrb0ehbre9hrb09her09hes0rhb9sehrb[0herb[0he[rb09he0rbherhboiehrb;oiehr[0he[rb0hw0rbh3[0bh93[0rbh3rbh[0rbhq3r9bh[0q3hrb0q3hr0h9hq3br0hq0rbhq3hroehrb0q3[hrq3hrb90q3hrb09hq309rbh093hrb09h3r90bh3q09hrb09qh3rb0hq039rhb0q3hrb[9qhrb09hq30rbhq30rhb09q3hrb09q3hr0[q3hrb09[3qhrqh3r0bh3[qr0b9h039rbh3[0qrbh3rb3qhr[b09h3qbr\nhrg[hrg[0rg\niehpgwiheoprghweg\neirhgpoiewhrg", image: "https://pbs.twimg.com/profile_images/2449186867/549619_348620965213858_1616045858_n.jpeg", history: "2sdf", category: .amrap, video: "9bZkp7q19f0", unit: .metric)
        selectedWOD?.results = [WODResult(), WODResult()]
        
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == customWodDetailsSegueIdentifier {
            let customWodDetailsVC = segue.destination as! CustomWODDetailsViewController
            customWodDetailsVC.wod = selectedWOD
        }
    }
}
