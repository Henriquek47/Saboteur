//
//  ImagePicker.swift
//  Saboteur
//
//  Created by Henrique Lima on 24/05/26.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  var sourceType: UIImagePickerController.SourceType = .camera
  @Environment(\.dismiss) private var dismiss

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      picker.sourceType = sourceType
    } else {
      picker.sourceType = .photoLibrary
    }
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let selectedImage = info[.originalImage] as? UIImage {
        parent.image = selectedImage
      }
      parent.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.dismiss()
    }
  }
}
