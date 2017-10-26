//
//  ViewController.swift
//  lightshow
//
//  Created by Benson Weeks on 10/25/17.
//  Copyright © 2017 Benson Weeks. All rights reserved.
//

import UIKit
import AVFoundation


class LightShowViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //    Mark: - Constants
    let imagePicker = UIImagePickerController()
    
    //    Mark: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self //wires up the delegate
    }
    
    func noCamera(){ //this will stop the simulator from crashing when the button is pressed
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true,completion: nil)
    }
    
    func noFlashlight() {
        // this will notify user they do not have access to a flashlight
        let AlertVC = UIAlertController(
            title: "No Flashlight",
            message: "Sorry, this device has no flashlight",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        AlertVC.addAction(okAction)
        present(AlertVC, animated: true, completion: nil)
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                noFlashlight()
            }
        } else {
            noFlashlight()
        }
    }
    
    @IBAction func turnTorchOn(_ sender: UIButton) {
        toggleTorch(on: true)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //take a new picture using the camera if there is one
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
            imageView.image = sender.currentImage
        }
        else {
            noCamera()
        }
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //    Mark: - Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}

