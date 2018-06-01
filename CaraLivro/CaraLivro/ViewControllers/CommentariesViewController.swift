//
//  CommentariesViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

final class CommentariesViewController: UIViewController, Storyboarded {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Comments"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
