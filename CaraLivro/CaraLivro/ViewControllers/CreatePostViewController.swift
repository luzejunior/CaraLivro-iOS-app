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
    
    var image: UIImage?
    var currentMuralUserID: Int?
    var currentMuralGroupID: Int?
    var coordinator: CreatePostViewControllerActions?
    var bottomConstraint: NSLayoutConstraint?
    var listType: ListType?
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
    
    var url = ""
    
    @objc func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    func printURL() {
        print(url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "CreatePost"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            let post = PostInUserMural(user_id_poster: currentUserInUse?.idUserProfile ?? 0, visibility: "public", text: inputText.text, attachment_type: attachmentType, attachment_path: attachmentPath)
            let stringURL = "user/" + String(describing: currentMuralUserID ?? 0) + "/mural/post"
            postDataToServer(object: post, path: stringURL) {
                DispatchQueue.main.async {
                    self.coordinator?.didTouchPostButton(listType: self.listType!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let post = PostIntoGroupMural(id_poster: currentMuralGroupID ?? 0, visibility: "public", text: inputText.text, attachment_type: attachmentType, attachment_path: attachmentPath)
            let stringURL = "group/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/mural/post"
            postDataToServer(object: post, path: stringURL) {
                DispatchQueue.main.async {
                    self.coordinator?.didTouchPostButton(listType: self.listType!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func uploadImage(completion: @escaping () -> ()){
        if ((self.image?.imageAsset) != nil){completion(); return;}
        guard let image = imagePicked.image else {
            return;
        }
        
        let dispatchGroup = DispatchGroup()
        let config = CLDConfiguration(cloudName: "dn1glubhp", apiKey: "718496462185294")
        let cloudinary = CLDCloudinary(configuration: config)
        
        dispatchGroup.enter()
        
        let size = CGSize(width: 360, height: 270)
        let imageResized = imageWithImage(image: image, scaledToSize: size)
        let data = UIImagePNGRepresentation(imageResized)
        cloudinary.createUploader().upload(data: data!, uploadPreset: "presetPamin")
            .response { (result, error) in
                if error == nil {
                    // Adiciona link à variavel url
                    self.url = (result?.url)!
                    dispatchGroup.leave()
                }else{
                    print("Erro: \(String(describing: error))")
                    dispatchGroup.leave()
                }
            }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapPostarButton(_ sender: Any) {
        if imagePicked.image != nil {
            postarButton.isEnabled = false
            postarButton.setTitle("Carregando...", for: .disabled)
            uploadImage {
                self.printURL()
                self.postButtonAction(attachmentType: "image", attachmentPath: self.url)
            }
        } else {
            postButtonAction(attachmentType: nil, attachmentPath: nil)
        }
    }
}
