//
//  LoginViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 05/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController, Storyboarded, FriendListTableViewCellConform, FriendListViewActions {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //tableView.isHidden = true
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }

    var presenter: LoginViewControllerPresenter?
    var coordinator: LoginViewControllerActions?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.dataSource = presenter?.dataSource
        presenter?.fetchData()
    }

    @IBAction func onAddButtonTouched(_ sender: Any) {
        let newUser = CreateUserJson(first_name: "Luzenildo", last_name: "Junior", email: "luzenildojunior@email.cu", password: "eusouhomem")
        postDataToServer(object: newUser, path: "user/signup") { () in
            DispatchQueue.main.async {
                self.presenter?.fetchData()
            }
        }
    }

    func RegisterCells() {
        tableView.register(FriendListTableViewCell.self)
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func didSelectedFriend(_ sender: FriendListTableViewCell) {
        coordinator?.didSelectedUserToLogin(currentUser: (sender.presenter?.user)!)
    }

    func presentUIAlert() {

    }
}

final class LoginViewControllerPresenter {

    var dataSource = GenericDataSource()
    private var view: LoginViewController?

    init(with view: LoginViewController) {
        self.view = view
    }

    func fetchData() {
        let stringURL = "users"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            apiUsers.removeAll()
            apiUsers.append(contentsOf: users)
            DispatchQueue.main.async {
                self.configureTableView()
            }
        }
    }

    func configureTableView() {
        dataSource.items.removeAll()
        for user in apiUsers {
            let tableContent = FriendListTableViewCellPresenter(userDetails: user, view: view!)
            dataSource.items.append(tableContent)
        }
        view?.finishedFetching()
    }
}
