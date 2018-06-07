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
        let stringURL = "http://192.168.100.100:3000/users"
        guard let url = URL(string: stringURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let users = try JSONDecoder().decode([UserDetails].self, from: data)
                apiUsers.append(contentsOf: users)
                DispatchQueue.main.async {
                    self.configureTableView()
                }
            } catch let jsonErr {
                print(jsonErr.localizedDescription)
            }
        }.resume()
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
