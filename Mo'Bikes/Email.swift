//
//  Email.swift
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-01.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import MessageUI


@objc class Email: UIViewController,MFMailComposeViewControllerDelegate {
    let destinationEmail = "sanjays_94@hotmail.com"
    var bikeOrDock:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reporting Damage"
        
    }
    
    func sendEmail(myName: String, qrCode:String, damageArray:Array<String>) -> Void {
     
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        //show error if the VC cant send mail
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        var damageArrayString:String = ""

        //make a string containing all our damages
        for var i in (0..<damageArray.count){
            damageArrayString = damageArrayString + "\n\(damageArray[i])"
            i = i+1
        }
        
        if(qrCode == "No QRCode on station"){
            bikeOrDock = "dock"
        }
        else {
            bikeOrDock = "bike"
        }
        
        //mailVC properties
        mailComposerVC.setToRecipients([destinationEmail])
        mailComposerVC.setSubject(myName + " is reporting damage")
        mailComposerVC.setMessageBody(("Hi,\n\nThe \(bikeOrDock) with the following QR Code has damage \n\nQRCode: " + qrCode + "\n\nDamages to:" + damageArrayString + "\n\nLove,\n"), isHTML: false)
    }
    
    //handling sending errors
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
            self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    //when were done with the mailComposerController
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
            case .cancelled: self.presentingViewController!.dismiss(animated: true)
            //not saving atm
            case .saved: print ("Go back to mapView")
            case .sent: self.performSegue(withIdentifier: "unwindToInitialVC", sender: self)
                         print ("Go back to mapView")
            
            case .failed:
            print ("Mail sent failure: \([error!.localizedDescription])")
        }
    }

}
