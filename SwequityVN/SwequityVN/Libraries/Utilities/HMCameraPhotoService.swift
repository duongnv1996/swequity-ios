//
//  HMCameraPhotoService.swift
//  TimXe
//
//  Created by Nguyễn Nam on 5/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

enum HMCameraPhotoServiceType {
    case camera, photoLibrary
}

class HMCameraPhotoService: NSObject {
    // MARK: - Singleton
    static var instance = HMCameraPhotoService()
    
    // MARK: - Closures
    private var didPickImage: ((_ image: UIImage?) -> Void)?
    
    func showScreenOf(type: HMCameraPhotoServiceType, canEdit: Bool = false, didDenyPermission: (() -> Void)? = nil, didPickImage: @escaping ((_ image: UIImage?) -> Void)) {
        func moveToImagePickerScreen() {
            let sourceType: UIImagePickerController.SourceType = type == .camera ? .camera : .photoLibrary
            guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
                didPickImage(nil)
                return
            }
            self.didPickImage = didPickImage
            let cameraView = UIImagePickerController()
            cameraView.delegate = self
            cameraView.sourceType = sourceType
            cameraView.allowsEditing = canEdit
            UIViewController.top()?.present(cameraView, animated: true, completion: nil)
        }
        if type == .camera {
            switch HMPermission.cameraAuthStatus {
            case .notDetermined:
                HMPermission.requestCameraPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                didDenyPermission?()
            default: break
            }
        } else {
            switch HMPermission.photoAuthStatus {
            case .notDetermined:
                HMPermission.requestPhotoPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                didDenyPermission?()
            default: break
            }
        }
    }
}

extension HMCameraPhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            guard let image = info[.originalImage] as? UIImage else {
                self.didPickImage?(nil)
                return
            }
            self.didPickImage?(image)
        })
    }
}

extension HMCameraPhotoService {
    static func compressImage(sourceImage: UIImage) -> Data? {
        var compression: CGFloat = 0.9
        let maxCompression: CGFloat = 0.1
        let maxFileSize = 1000*1024;
        
        var imageData = sourceImage.jpegData(compressionQuality: compression)
        
        while ((imageData?.count)! > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = sourceImage.jpegData(compressionQuality: compression)
        }
        
        let countBytes = ByteCountFormatter()
        countBytes.allowedUnits = [.useMB]
        countBytes.countStyle = .file
        let fileSize = countBytes.string(fromByteCount: Int64(imageData!.count))
        
        print("File size: \(fileSize)")
        return imageData
    }
}
