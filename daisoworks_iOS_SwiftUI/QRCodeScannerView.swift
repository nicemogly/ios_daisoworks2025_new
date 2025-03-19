import SwiftUI

import AVFoundation



struct QRCodeScannerView: UIViewControllerRepresentable {

    @Binding var scannedCode: String? // 스캔된 결과를 저장할 바인딩 변수
    @Binding var isPresentingScanner: Bool// 스캔된 결과를 저장할 바인딩 변수
    



    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

        var parent: QRCodeScannerView
        init(parent: QRCodeScannerView) {
            self.parent = parent
        }



        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                let stringValue = metadataObject.stringValue{
 
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // 스캔시 진동
                DispatchQueue.main.async {
                  
                    self.parent.scannedCode = stringValue // QR 결과를 저장
                    self.parent.isPresentingScanner = false

                }
            }

        }

    }



    func makeCoordinator() -> Coordinator {

        Coordinator(parent: self)

    }



    func makeUIViewController(context: Context) -> UIViewController {

        let viewController = UIViewController()

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720


        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }

        let videoInput: AVCaptureDeviceInput



        do {

            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

        } catch {

            return viewController

        }



        if captureSession.canAddInput(videoInput) {

            captureSession.addInput(videoInput)

        } else {

            return viewController

        }



        let metadataOutput = AVCaptureMetadataOutput()



        if captureSession.canAddOutput(metadataOutput) {

            captureSession.addOutput(metadataOutput)



            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)

            metadataOutput.metadataObjectTypes = [.qr] // QR 코드만 스캔

        } else {

            return viewController

        }

        if let device = AVCaptureDevice.default(for: .video) {
            try? device.lockForConfiguration()
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            device.unlockForConfiguration()
        }
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        previewLayer.frame = viewController.view.layer.bounds

        previewLayer.videoGravity = .resizeAspectFill

        viewController.view.layer.addSublayer(previewLayer)


        
        captureSession.startRunning()

        return viewController

    }



    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

}
