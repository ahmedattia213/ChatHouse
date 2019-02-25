//
//  pickck.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/6/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//
import UIKit
import MobileCoreServices
import AVFoundation

public protocol ImagePickerDelegate: class {
    func didSelect(selectedMedia: Any?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = [kUTTypeImage] as [String]
        if presentationController.isKind(of: ChatLogController.self) {
            self.pickerController.mediaTypes.append(kUTTypeMovie as String)
        }
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect media: Any?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(selectedMedia: media)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)

    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let videoUrl = info[.mediaURL] as? URL {
            self.pickerController(picker, didSelect: videoUrl )
            return
        }
        if let image = info[.editedImage] as? UIImage {
            self.pickerController(picker, didSelect: image)
            return
        }
        self.pickerController(picker, didSelect: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
