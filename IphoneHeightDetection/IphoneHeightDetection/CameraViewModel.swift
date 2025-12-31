//
//  CameraViewModel.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    let session = AVCaptureSession()

    init() {
        checkPermissions()
    }

    private func checkPermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        print("Camera auth status:", status.rawValue)

        if status == .authorized {
            setupSession()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupSession()
                    }
                }
            }
        }
    }

    private func setupSession() {
        guard session.inputs.isEmpty else { return }

        session.beginConfiguration()
        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            print("Failed to create camera input")
            session.commitConfiguration()
            return
        }

        session.addInput(input)
        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            print("Session running:", self.session.isRunning)
        }
    }
}
