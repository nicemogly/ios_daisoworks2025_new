//
//  Untitled.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/16/24.
//
import SwiftUI
import AVFoundation
import Vision
 

class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            self.detectBarcode(in: pixelBuffer)
        }
        
        func detectBarcode(in pixelBuffer: CVPixelBuffer) {
            let request = VNDetectBarcodesRequest()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            
            do {
                try handler.perform([request])
                if let results = request.results, let payload = results.first?.payloadStringValue {
                    Task {
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        self.parent.scannedString = payload
                        self.parent.itemId = payload
                        self.parent.scnflag.toggle()
                    }
                    // Optionally, stop scanning after first detection
                    // self.parent.captureSession.stopRunning()
                }
            } catch {
                print("Barcode detection failed: \\(error)")
            }
        }
    }
