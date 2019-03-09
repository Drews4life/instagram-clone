//
//  CameraViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/9/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            
            } catch {
                debugPrint("Could not set camera input: \(error.localizedDescription)")
            }
        }
    }
}
