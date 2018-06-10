//
//  FriendListViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

// PRESENTER
final class FriendListViewControllerPresenter {
    var dataSource = GenericDataSource()
    private var view: FriendListViewController?
    var currentUserID: Int?
    var listType: ListType?
    var listAll = false

    init(with view: FriendListViewController, listType: ListType, currentUserID: Int) {
        self.view = view
        self.currentUserID = currentUserID
        self.listType = listType

    }
    
    func fetchData() {
        dataSource.items.removeAll()
        if listType == .friends {
            var stringURL = ""
            if listAll {
                stringURL = "users"
            } else {
                stringURL = "user/" + String(describing: currentUserID ?? 0) + "/friends"
            }
            getDataFromServer(path: stringURL) { (users: [UserDetails]) in
                DispatchQueue.main.async {
                    self.configureFriendListTableView(posts: users)
                }
            }
        }
        if listType == .groups {
            let stringURL = "groups"
            getDataFromServer(path: stringURL) { (groups: [GroupsDetails]) in
                DispatchQueue.main.async {
                    self.configureGroupListTableView(posts: groups)
                }
            }
        }
        view?.loadList()
    }
    
    func configureFriendListTableView(posts: [UserDetails]) {
        dataSource.items.removeAll()
        for user in posts {
            let tableContent = FriendListTableViewCellPresenter(userDetails: user, view: view!, list: .friends)
            dataSource.items.append(tableContent)
        }
        view?.finishedFetching()
    }
    
    func configureGroupListTableView(posts: [GroupsDetails]) {
        dataSource.items.removeAll()
        for group in posts {
            let tableContent1 = FriendListTableViewCellPresenter(groupDetails: group, view: view!)
            dataSource.items.append(tableContent1)
        }
        view?.finishedFetching()
    }
}

// CONTROLLER
final class FriendListViewController: UIViewController, Storyboarded, FriendListTableViewCellConform, FriendListViewActions {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    
    var presenter: FriendListViewControllerPresenter?
    var coordinator: MainCoordinator?

    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenter?.listType == .friends {
            navigationController?.navigationBar.topItem?.title = "Friends List"
        } else {
            navigationController?.navigationBar.topItem?.title = "Groups List"
        }
    }

    public func presentUIAlert () {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Recusar", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(title: "Listar Todos", style: .plain, target: self, action: #selector(self.listAll))
        self.navigationItem.rightBarButtonItem  = button1
        presenter?.fetchData()
        tableView.dataSource = presenter?.dataSource
    }

    @objc func listAll() {
        presenter?.listAll = true
        presenter?.fetchData()
    }
    
    func finishedFetching() {
        tableView.reloadData()
    }
    
    func RegisterCells() {
        tableView.register(FriendListTableViewCell.self)
    }

    func didSelectedFriend(_ sender: FriendListTableViewCell) {
        let senderType = sender.presenter?.listType
        if senderType == .groups {
            coordinator?.didTouchGroup(group: (sender.presenter?.group)!)
        }
    }
    
    func loadList() {
        if presenter?.dataSource.items.isEmpty ?? true {
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
}
