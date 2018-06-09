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
    func didTouchPostButton()
}

final class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storyboarded {

    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var imagePicked: UIImageView!
    
    var image: UIImage?
    var currentMuralUserID: Int?
    var coordinator: CreatePostViewControllerActions?
    var bottomConstraint: NSLayoutConstraint?
    
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
    
    @objc private func imagePickerController(_private  picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
        self.uploadImage(completion: printURL)
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
        let button1 = UIBarButtonItem(title: "Postar", style: .plain, target: self, action: #selector(self.postButtonAction))
        self.navigationItem.rightBarButtonItem  = button1
        
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
    
    @objc func postButtonAction() {
        let post = PostInUserMural(user_id_poster: currentUserInUse?.idUserProfile ?? 0, visibility: "public", text: inputText.text)
        let stringURL = "user/" + String(describing: currentMuralUserID ?? 0) + "/mural/post"
        postDataToServer(object: post, path: stringURL) {
            DispatchQueue.main.async {
                self.coordinator?.didTouchPostButton()
            }
        }
    }
    
    func uploadImage(completion: @escaping () -> ()){
        
        if ((self.image?.imageAsset) != nil){completion(); return;}
        
        let dispatchGroup = DispatchGroup()
        let config = CLDConfiguration(cloudName: "dn1glubhp", apiKey: "718496462185294")
        let cloudinary = CLDCloudinary(configuration: config)
        
        dispatchGroup.enter()
        
        let size = CGSize(width: 360, height: 270)
        let imageResized = imageWithImage(image: imagePicked.image!, scaledToSize: size)
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
    
}
