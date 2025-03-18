//
//  QRCodeScannerView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/18/25.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode : String? //스캔된 결과를 저장할 바인딩변수
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        
        init(parent: QRCodeScannerView){
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first{
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue  = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //스캔시 진동
                parent.scannedCode = stringValue // QR 결과를 저장
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            return viewController
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else{
            return viewController
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        }else{
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
