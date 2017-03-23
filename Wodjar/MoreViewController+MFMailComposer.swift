//
//  MoreViewController+MFMailComposer.swift
//  Wodjar
//
//  Created by Mihai Erős on 22/03/2017.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import MessageUI

extension MoreViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: - MFMailComposer Delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        guard let error = error else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        handle(error)
    }
    
    // MARK: - Mail Utils
    
    func sendMail() {
        let mailVC = MFMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["contact@x2mobile.net"])
            mailVC.setSubject("Feedback WOD Journal iOS App")
            
            present(mailVC, animated: true, completion: nil)
        }
    }
}
