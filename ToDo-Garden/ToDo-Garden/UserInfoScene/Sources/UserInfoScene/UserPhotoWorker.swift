//
//  UserPhotoWorker.swift
//
//
//  Created by Wood on 9/8/24.
//

import PhotosUI

public final class UserPhotoWorker: PHPickerViewControllerDelegate {
  private var selectedImagesHandler: ((UIImage?, Error?) -> Void)?

  public init() {}

  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)

    if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { (loadedObject, error) in
        let newProfileImage = loadedObject as? UIImage
        self.selectedImagesHandler?(newProfileImage, error)
      }
    }
  }

  func requestPhotoAccess() async -> Bool {
    let status = await PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite)
    if status == PHAuthorizationStatus.authorized || status == PHAuthorizationStatus.limited {
      return true
    } else {
      return false
    }
  }

  func requestPhoto() async throws -> UIImage {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      self?.selectedImagesHandler = { image, error in
        if let image {
          continuation.resume(returning: image)
        } else {
          let error = error ?? UserPhotoworkerError.unknownError
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

public enum UserPhotoworkerError: Error {
  case unknownError
}
