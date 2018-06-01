//
//  CreatePostViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

final class CreatePostViewController: UIViewController, Storyboarded {

    @IBOutlet weak var inputText: UITextView!


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "CreatePost"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.placeholder = "Digite seu texto"
    }
}
