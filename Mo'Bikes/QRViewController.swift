//
//  QRViewController.swift
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-01.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import AVFoundation

@objc class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet weak var statusLabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var didDetect: Bool?
    
    var damageArray: Array<String>?
    
    let supportedCodeTypes =  [AVMetadataObjectTypeQRCode]
    

    
    override func viewDidAppear(_ animated: Bool) {
        didDetect = false;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: statusLabel)
            //view.bringSubview(toFront: topbar)
            
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            

            
            return
        }

        
        

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            statusLabel.text = "No QR/barcode is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                statusLabel.text = metadataObj.stringValue
                
                //segue to mail app.
            
                if(didDetect == false)
                {
                    self.sendMail()
                }
                didDetect = true
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func sendMail(){
        
        
        
        // set modal presentation style to popover on your view controller
        // must be done before you reference controller.popoverPresentationController
        //newEmail.modalPresentationStyle = UIModalPresentationPopover;
        //newEmail.preferredContentSize = CGSizeMake(150, 300);
        
        // configure popover style & delegate
        //UIPopoverPresentationController *popover =  newEmail.popoverPresentationController;
        //newEmail.popoverPresentationController.delegate = newEmail;
        //newEmail.popoverPresentationController.sourceView = self.view;
        
        // newEmail.popoverPresentationController.sourceRect = CGRectMake(150,300,1,1);
        //newEmail.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        //right now just static info

       
        // display the controller in the usual way
            //self.present(newEmail, animated: true, completion: nil)
        self.performSegue(withIdentifier:"showEmailVCSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showEmailVCSegue" ){
            
            let newEmail = segue.destination as! Email
            
                newEmail.sendEmail(myName: "Sanjay Shah", qrCode: "\(statusLabel.text ?? "No QRCode")", damageArray: damageArray!)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
