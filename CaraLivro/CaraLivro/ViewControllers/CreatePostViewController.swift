//
//  CreatePostViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

protocol CreatePostViewControllerActions {
    func didTouchPostButton(listType: ListType)
}

final class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storyboarded {

    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var publicPrivateButton: UIButton!

    var currentMuralUserID: Int?
    var currentMuralGroupID: Int?
    var coordinator: CreatePostViewControllerActions?
    var bottomConstraint: NSLayoutConstraint?
    var listType: ListType?
    var publicFlag = "public"
    @IBOutlet weak var postarButton: UIButton!

    let addImagemInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let addImagemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Adicionar Imagem", for: .normal)
        button.addTarget(self, action: #selector(openPhotoLibraryButton), for: .touchUpInside)
        return button
    }()
    
    @objc func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var image: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = (info[UIImagePickerControllerEditedImage] as! UIImage)
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "NOVO POST"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        inputText.placeholder = "Digite seu texto"
        inputText.layer.cornerRadius = 10
        
        view.addSubview(addImagemInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: addImagemInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: addImagemInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: addImagemInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                // Ajustar a tableview quando o textField for selecionado.
            })
        }
    }
    
    func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        addImagemInputContainerView.addSubview(addImagemButton)
        addImagemInputContainerView.addSubview(topBorderView)
        
        addImagemInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0]|", views: addImagemButton)
        
        addImagemInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: addImagemButton)
        
        addImagemInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        addImagemInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    func postButtonAction(attachmentType: String?, attachmentPath: String?) {
        if listType == .friends {
            let post = PostInUserMural(user_id_poster: currentUserInUse?.idUserProfile ?? 0, visibility: publicFlag, text: inputText.text, attachment_type: attachmentType, attachment_path: attachmentPath)
            let stringURL = "user/" + String(describing: currentMuralUserID ?? 0) + "/mural/post"
            postDataToServer(object: post, path: stringURL) {
                DispatchQueue.main.async {
                    self.coordinator?.didTouchPostButton(listType: self.listType!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let post = PostIntoGroupMural(id_poster: currentMuralGroupID ?? 0, visibility: publicFlag, text: inputText.text, attachment_type: attachmentType, attachment_path: attachmentPath)
            let stringURL = "group/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/mural/post"
            postDataToServer(object: post, path: stringURL) {
                DispatchQueue.main.async {
                    self.coordinator?.didTouchPostButton(listType: self.listType!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapPostarButton(_ sender: Any) {
        if imagePicked.image != nil {
            postarButton.isEnabled = false
            postarButton.setTitle("Carregando...", for: .disabled)
            uploadImage(image: image) { (url) in
                self.postButtonAction(attachmentType: "image", attachmentPath: url)
            }
        } else {
            postButtonAction(attachmentType: nil, attachmentPath: nil)
        }
    }

    @IBAction func didTapPublic(_ sender: Any) {
        if publicFlag == "public" {
            publicPrivateButton.setTitle("Privado", for: .normal)
            publicFlag = "private"
        } else {
            publicPrivateButton.setTitle("Público", for: .normal)
            publicFlag = "public"
        }
    }

}
