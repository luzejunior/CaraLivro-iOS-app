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
    
    var url = ""
    
    @IBAction func openPhotoLibraryButton(sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
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
