//
//  CreateGroupViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 12/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class CreateGroupViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator?

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupDescription: UITextView!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        groupDescription.layer.borderWidth = 1.0
        groupDescription.layer.cornerRadius = 5
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func didTapCreateGroupButton(_ sender: Any) {
        createButton.isEnabled = false
        createButton.setTitle("Carregando...", for: .disabled)
        postCreateButtonAction(attachmentType: nil, attachmentPath: nil)
    }

    func postCreateButtonAction(attachmentType: String?, attachmentPath: String?) {
        let newGroup = CreateGroupJson(name: groupName.text!, description: groupDescription.text!, user_creator_id:currentUserInUse?.idUserProfile ?? 0)
        let stringURL = "group/create"
        postDataToServer(object: newGroup, path: stringURL) {
            DispatchQueue.main.async {
                self.coordinator?.didDismissCadastro()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
