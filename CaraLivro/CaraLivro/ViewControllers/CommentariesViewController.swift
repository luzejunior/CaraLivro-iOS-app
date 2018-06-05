//
//  CommentariesViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit
import StringStylizer

final class CommentariesViewController: UIViewController, Storyboarded {

    var dataSource = GenericDataSource()
    var string: NSAttributedString?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Comments"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func loadCommentaries() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
