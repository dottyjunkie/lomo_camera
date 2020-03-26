//
//  ViewController.swift
//  lomo
//
//  Created by 吳大均 on 2020/3/26.
//  Copyright © 2020 turing-junkie. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var cameraview: UIView!
    
    
    var session : AVCaptureSession?
    var videopreviewlayer : AVCaptureVideoPreviewLayer?
    var carmera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
    var capturePhotoOutput : AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
            
        let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)

        do{
            let input = try AVCaptureDeviceInput(device : captureDevice!)

            session = AVCaptureSession()
            session?.addInput(input)

            videopreviewlayer = AVCaptureVideoPreviewLayer(session : session!)
            videopreviewlayer?.frame = view.layer.bounds
            cameraview.layer.addSublayer(videopreviewlayer!)
            session?.startRunning()

        }catch{
            print("ERROR")
        }
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        session?.addOutput(capturePhotoOutput!)
    }

    
    @IBAction func capturephoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else {
             return
         }
         let photosettings = AVCapturePhotoSettings()
         photosettings.isHighResolutionPhotoEnabled = true
         photosettings.isAutoStillImageStabilizationEnabled = true
         //debug
         capturePhotoOutput.capturePhoto(with: photosettings, delegate: self )
    }
}

extension ViewController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer : CMSampleBuffer?,
                     previewPhoto previewphotoSampleBuffer : CMSampleBuffer?,
                     resolvedSettings : AVCaptureResolvedPhotoSettings,
                     brackestSettings : AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        guard error == nil,
           let photoSampleBuffer = photoSampleBuffer else {
            print("ERROR")
            return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
            forJPEGSampleBuffer: photoSampleBuffer,
            previewPhotoSampleBuffer: previewphotoSampleBuffer) else {
            return
        }
        
        let captureImage = UIImage.init(data : imageData,
                                        scale: 1.0)
        if let image = captureImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

