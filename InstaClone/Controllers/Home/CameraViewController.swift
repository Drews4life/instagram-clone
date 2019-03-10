//
//  CameraViewController.swift
//  InstaClone
//
//  Created by Andrii Zakharenkov on 3/9/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    let dismissBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(onBackButtonClick), for: .touchUpInside)
        
        return btn
    }()
    
    let capturePhotoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(onTakePhotoClick), for: .touchUpInside)
        
        return btn
    }()
    
    private let captureOutput = AVCapturePhotoOutput()
    
    let customAnimationPresenter = CustomAnimationPresenter()
    let customAnimationDismissor = CustomAnimationDismissor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        
        setupCaptureSession()
        setupButtons()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismissor
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupButtons() {
        view.addSubview(capturePhotoBtn)
        view.addSubview(dismissBtn)
        
        capturePhotoBtn.anchor(top: nil, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 30, width: 80, height: 80)
        capturePhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissBtn.anchor(top: view.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, paddingTop: 12, paddingRight: 12, paddingLeft: 0, paddingBottom: 0, width: 50, height: 50)
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
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    @objc func onTakePhotoClick() {
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//
//        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
//
//        let previewImage = UIImage(data: imageData!)
//
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let err = error {
            debugPrint("Error happened while capturing photo: ", err.localizedDescription)
            return
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingRight: 0, paddingLeft: 0, paddingBottom: 0, width: 0, height: 0)
        
    }
    
    @objc func onBackButtonClick() {
        dismiss(animated: true, completion: nil)
    }
}
