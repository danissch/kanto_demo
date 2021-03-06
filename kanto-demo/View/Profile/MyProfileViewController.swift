//
//  MyProfileViewController.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation
import UIKit
import Kingfisher
protocol MyProfileViewControllerDelegate {
    func onSaveData()
}
class MyProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textFieldBiography: UITextField!
    
    @IBOutlet weak var changePhotoButton: UIButton!
    
    
    var imageToSave:UIImage!
    var delegate: MyProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualConfig()
        self.hideKeyboardWhenTappedAround()
        accesToCam()
        setupData()
    }
    
    var pickerController = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupVisualConfig()
    }
    
    func setupVisualConfig(){
        self.view.backgroundColor = UIColor.init(red: 23/255, green: 22/255, blue: 40/255, alpha: 1.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        changePhotoButton.clipsToBounds = true
        changePhotoButton.layer.cornerRadius = 15
        changePhotoButton.backgroundColor = UIColor.init(red: 35/255, green: 34/255, blue: 50/255, alpha: 1.0)
        
        
        setStyle1TextField(textField: textfieldName)
        setStyle1TextField(textField: textfieldUsername)
        setStyle1TextField(textField: textFieldBiography)
        
    }
    
    func setStyle1TextField(textField:UITextField){
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        textField.delegate = self
    }
    
    func setStyle2TextField(textField:UITextField){
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
        textField.delegate = self
    }
    
    func setupData(){
        self.imageToSave = PersistanceManager.sharedInstance.loadimg()
        self.textfieldName.text = PersistanceManager.sharedInstance.profileName
        self.textfieldUsername.text = PersistanceManager.sharedInstance.profileUserName
        self.textFieldBiography.text = PersistanceManager.sharedInstance.profileBiography
        self.profileImageView.image = self.imageToSave
    }
    
    @IBAction func changePhotoAction(_ sender: Any) {
        pickPhoto()
    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        saveData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigateBack()
    }
    
    
    func saveData(){
        
        if textfieldName.text == "" || textfieldUsername.text == "" || textFieldBiography.text == "" {
            let alert = UIAlertController(title: "Validation", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        PersistanceManager.sharedInstance.saveimg(image: self.imageToSave!)
        PersistanceManager.sharedInstance.profileName = self.textfieldName.text ?? ""
        PersistanceManager.sharedInstance.profileUserName = self.textfieldUsername.text ?? ""
        PersistanceManager.sharedInstance.profileBiography = self.textFieldBiography.text ?? ""
        delegate?.onSaveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func accesToCam(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController.init(title: nil,
                message: "No camera available.",
                preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK",
                style: .default,
                handler: {(alert: UIAlertAction!) in })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }

    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil,
        preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
        handler: nil)
        alert.addAction(actCancel)

        let actPhoto = UIAlertAction(title: "Take Photo",
        style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })

        alert.addAction(actPhoto)

        let actLibrary = UIAlertAction(title: "Choose From Library",
        style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
            })

        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary(){
        
        pickerController.delegate = self 
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    func takePhotoWithCamera(){
        pickerController.sourceType = .camera
        pickerController.cameraCaptureMode = .photo
        pickerController.cameraDevice = UIImagePickerController.CameraDevice.front
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let capturedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                picker.dismiss(animated: true, completion: nil)
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.backgroundColor = UIColor.clear
            self.imageToSave = capturedImage
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.profileImageView.image = capturedImage
            })
        }
        
        pickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MyProfileViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -220 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}

extension MyProfileViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setStyle2TextField(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setStyle1TextField(textField: textField)
    }
}
