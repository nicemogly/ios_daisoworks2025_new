//
//  QRCodeScannerView1.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 4/3/25.
//
import SwiftUI
import AVFoundation


struct QRCodeScannerView1: UIViewControllerRepresentable {
    var onCodeScanned: (String) -> Void
    
    let captureSession = AVCaptureSession()
    
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView1
        
        init(parent: QRCodeScannerView1){
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject ,
               let qrCodeValue = metadataObject.stringValue {
                   // print("QR CODE: \(qrCodeValue)")
                   // parent.onCodeScanned(qrCodeValue)
                     DispatchQueue.main.async {
                         self.parent.onCodeScanned(qrCodeValue)
                     }
                }
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) ->  UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        
        //videoCaptureDevice.autoFocusRangeRestriction = .near
       // videoCaptureDevice.focusMode = .continuousAutoFocus
        
        if let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice){
            if session.canAddInput(videoInput) {
                
                session.addInput(videoInput)
            }
        }
      
        let metadataOutput = AVCaptureMetadataOutput()
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            session.sessionPreset = .high
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        
//        if videoCaptureDevice.isFocusModeSupported(.continuousAutoFocus) {
//            videoCaptureDevice.focusMode = .continuousAutoFocus
//        }
//        
//        if videoCaptureDevice.isAutoFocusRangeRestrictionSupported {
//            videoCaptureDevice.autoFocusRangeRestriction = .near
//        }
   
        
      let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        viewController.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
  
}
