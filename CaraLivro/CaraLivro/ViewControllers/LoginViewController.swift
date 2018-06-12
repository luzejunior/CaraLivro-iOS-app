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
            tableView.backgroundColor = .white
            RegisterCells()
        }
    }

    var presenter: LoginViewControllerPresenter?
    var coordinator: LoginViewControllerActions?
    
    var refreshControl = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.dataSource = presenter?.dataSource
        presenter?.fetchData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        presenter?.fetchData()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func onAddButtonTouched(_ sender: Any) {
        coordinator?.didTouchAddUserButton()
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

    func presentUIAlert(postID: Int, postOwnerID: Int) {

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
            let tableContent = FriendListTableViewCellPresenter(userDetails: user, view: view!, list: .friends)
            dataSource.items.append(tableContent)
        }
        view?.finishedFetching()
    }
}
