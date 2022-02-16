//
//  QRViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 16/11/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var previenView: UIView!
    @IBOutlet weak var lbOutPut: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        print("llegue aqui")
        // Get an instance of the AVCaptureDevice class to initialize a
              // device object and provide the video as the media type parameter
              guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                  fatalError("No video device found")
              }
                                    
              do {
                  // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
                  let input = try AVCaptureDeviceInput(device: captureDevice)
                         
                  // Initialize the captureSession object
                  let captureSession = AVCaptureSession()
                         
                  // Set the input device on the capture session
                captureSession.addInput(input)
                         
                  // Get an instance of ACCapturePhotoOutput class
                  let capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput.isHighResolutionCaptureEnabled = true
                         
                  // Set the output on the capture session
                captureSession.addOutput(capturePhotoOutput)
                captureSession.sessionPreset = .high
                         
                  // Initialize a AVCaptureMetadataOutput object and set it as the input device
                  let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                         
                  // Set delegate and use the default dispatch queue to execute the call back
                  captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
                  captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                         
                  //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer.frame = view.layer.bounds
                previenView.layer.addSublayer(videoPreviewLayer)
                  //start video capture
                captureSession.startRunning()
                         
              } catch {
                  //If any error occurs, simply print it out
                  print(error)
                  return
              }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        //self.captureSession?.stopRunning()
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                    self.lbOutPut.text = outputString
                    let aler = UIAlertController(title: "Agregar producto", message: "SE agregara a ventas el producto" + outputString, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "simon", style: .default, handler: nil)
                    
                    let actionCancel = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
                    
                    aler.addAction(action)
                    aler.addAction(actionCancel)
                    self.present(aler, animated: true, completion: nil)
                //    self.previenView.isHidden = true
                }
            }
        }
        
    }



}
