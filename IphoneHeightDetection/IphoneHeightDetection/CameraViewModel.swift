//
//  CameraViewModel.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//

import SwiftUI
import AVFoundation
import Combine
import Vision

class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    @Published var personBoxes: [CGRect] = []

    override init() {
        super.init()
        checkPermissions()
    }

    private func checkPermissions() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            setupSession()
        }
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else { return }

        session.addInput(input)

        videoOutput.setSampleBufferDelegate(self,
                                            queue: DispatchQueue(label: "video.queue"))
        session.addOutput(videoOutput)

        session.commitConfiguration()
        session.startRunning()
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectHumanRectanglesRequest { request, _ in
            guard let results = request.results as? [VNHumanObservation] else { return }

            DispatchQueue.main.async {
                self.personBoxes = results.map { $0.boundingBox }
            }
        }
        request.upperBodyOnly = false

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: .right,
                                            options: [:])
        try? handler.perform([request])
    }
}
