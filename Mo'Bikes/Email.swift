//
//  Email.swift
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-01.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import MessageUI


class Email: UIViewController,MFMailComposeViewControllerDelegate {
    let destinationEmail = "sanjays_94@hotmail.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.popoverPresentationController!.delegate = self;
        self.title = "Reporting Damage"
        
    }
    
    func sendEmail(myName: String, qrCode:String, damageArray:Array<Any>) -> Void {
     
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        //show error if the VC cant send mail
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
//        if(!MFMailComposeViewController.canSendMail()){
//            self.showSendMailErrorAlert()
//        }
        
        //mailVC properties
        mailComposerVC.setToRecipients([destinationEmail])
        mailComposerVC.setSubject(myName + " is reporting damage")
        mailComposerVC.setMessageBody(("Hi,\n the bike with the following QR Code has damage \n\nQRCode:" + qrCode + "\nDamages: \(damageArray[0])" + "\n\nLove," + myName), isHTML: false)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
            self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
            case .cancelled: self.presentingViewController!.dismiss(animated: true)
            case .saved:
            print ("Go back to mapView")
        case .sent:
                self.performSegue(withIdentifier: "unwindToInitialVC", sender: self)
             print ("Go back to mapView")
            
            case .failed:
            print ("Mail sent failure: \([error!.localizedDescription])")
        }
        
        
        
    }
    


}
