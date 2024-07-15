//
//  PhotoLibraryViewModel.swift
//  Cuevision
//
//  Created by Kyrell Leano Siauw on 16/07/24.
//

import SwiftUI
import PhotosUI

class PhotoLibraryViewModel: NSObject, ObservableObject, PHPickerViewControllerDelegate {
    @Published var selectedImage: UIImage? = nil

    func showPhotoPicker() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // Allow single selection only
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        window.rootViewController?.present(picker, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let result = results.first {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    guard let self = self else { return }
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}
