//
//  ScannerView2.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 4/4/25.
//

import SwiftUI
import AVFoundation
import Vision

 
struct ScannerView2: UIViewControllerRepresentable {
    
    @Binding var scannedString1: String
    @Binding var scnflag1: Bool
    @Binding var itemId1: String
   
    
    let captureSession = AVCaptureSession()
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else { return viewController }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(videoOutput) {
            videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        //previewLayer.frame = CGRect(x: 50, y: 0, width: 300, height: 300)
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
       
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator2 {
        Coordinator2(self)
    }
    
}

