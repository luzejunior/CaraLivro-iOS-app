//
//  CadastroViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 10/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class CadastroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storyboarded {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var image: UIImage?
    var coordinator: MainCoordinator?
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.cropAsCircleWithBorder(borderColor: UIColor.black, strokeWidth: 2.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.image = UIImage(named: "profilePic")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        openPhotoLibraryButton()
    }
    
    func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImage.image = image
        dismiss(animated:true, completion: nil)
    }

    @IBAction func didTapCreateUserButton(_ sender: Any) {
        if userImage.image != UIImage(named: "profilePic") {
            createButton.isEnabled = false
            createButton.setTitle("Carregando...", for: .disabled)
            uploadImage(image: image) { (url) in
                self.postCreateButtonAction(attachmentType: "image", attachmentPath: url)
            }
        } else {
            postCreateButtonAction(attachmentType: nil, attachmentPath: nil)
        }
    }
    
    func postCreateButtonAction(attachmentType: String?, attachmentPath: String?) {
        let newUser = CreateUserJson(first_name: firstNameTextField.text!, last_name: secondNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, profile_pic: attachmentPath)
        let stringURL = "user/signup"
        postDataToServer(object: newUser, path: stringURL) {
            DispatchQueue.main.async {
                self.coordinator?.didDismissCadastro()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
