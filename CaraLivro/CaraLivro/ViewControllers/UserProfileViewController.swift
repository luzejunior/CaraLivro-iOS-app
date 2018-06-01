//
//  UserProfileViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

// PRESENTER
final class UserProfileViewControllerPresenter {
    var dataSource = GenericDataSource()
    var currentUser: UserDetails?
    private var view: UserProfileViewController?

    init(with view: UserProfileViewController, currentUser: UserDetails) {
        self.view = view
        self.currentUser = currentUser
    }

    func fetchData() {
        for item in testPosts {
            if item.userPosted?.userName == currentUser?.userName {
                let tableContent = FeedTableViewCellPresenter(textPost: item)
                dataSource.items.append(tableContent)
            }
        }
        view?.finishedFetching()
    }
}

// CONTROLLER
final class UserProfileViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!

    @IBAction func friendListButton(_ sender: Any) {
        coordinator?.didTouchFriendListButton()
    }

    @IBAction func groupsButton(_ sender: Any) {
        coordinator?.didTouchGroupsButton()
    }

    @IBAction func postButton(_ sender: Any) {
    }

    var presenter: UserProfileViewControllerPresenter?
    var coordinator: UserProfileViewControllerActions?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Profile"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = presenter?.dataSource
        configureUser()
        presenter?.fetchData()
    }

    func configureUser() {
        userImage.image = UIImage(named: presenter?.currentUser?.userImage ?? "")
        userName.text = presenter?.currentUser?.userName ?? ""
        userEmail.text = presenter?.currentUser?.userEmail ?? ""
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}
