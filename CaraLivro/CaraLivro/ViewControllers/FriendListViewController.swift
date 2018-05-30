//
//  FriendListViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

final class FriendListViewControllerPresenter {
    var dataSource = GenericDataSource()
    private var view: FriendListViewController?

    init(with view: FriendListViewController) {
        self.view = view
    }
}

final class FriendListViewController: UIViewController, Storyboarded {

    var presenter: FriendListViewControllerPresenter?
    var coordinator: Coordinator?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = FriendListViewControllerPresenter(with: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Friends List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
