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


final class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storyboarded {

    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var imagePicked: UIImageView!
    
    var image: UIImage?
    
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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
