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
    var currentGroupID: Int?
    var listType: ListType?
    var isGroupAdmin = false

    init(with view: FriendListViewController, listType: ListType, currentUserID: Int) {
        self.view = view
        self.currentUserID = currentUserID
        self.listType = listType
    }

    init(with view: FriendListViewController, listType: ListType, currentGroupID: Int) {
        self.view = view
        self.currentGroupID = currentGroupID
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
        } else if listType == .friendRequests {
            let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/received"
            getDataFromServer(path: stringURL) { (users: [UserDetails]) in
                DispatchQueue.main.async {
                    self.configureFriendListTableView(posts: users)
                }
            }
        } else if listType == .groups {
            var stringURL = ""
            if listAll {
                stringURL = "groups"
            } else {
                stringURL = "user/" + String(describing: currentUserID ?? 0) + "/groups"
            }
            getDataFromServer(path: stringURL) { (groups: [GroupsDetails]) in
                DispatchQueue.main.async {
                    self.configureGroupListTableView(posts: groups)
                }
            }
        } else if listType == .groupRequests {
            let stringURL = "group/" + String(describing: currentGroupID ?? 0) + "/requests/pending"
            getDataFromServer(path: stringURL) { (users: [UserDetails]) in
                DispatchQueue.main.async {
                    self.configureFriendListTableView(posts: users)
                }
            }
        } else if listType == .groupMembers {
            let stringURL = "group/" + String(describing: currentGroupID ?? 0) + "/members"
            getDataFromServer(path: stringURL) { (users: [UserDetails]) in
                DispatchQueue.main.async {
                    self.configureFriendListTableView(posts: users)
                }
            }
        }
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
            tableView.isHidden = true
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

    public func presentUIAlert(postID: Int, postOwnerID: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        if presenter?.listType == .friends && presenter?.listAll == false {
            alert.addAction(UIAlertAction(title: "Desfazer Amizade", style: .destructive, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Bloquear", style: .destructive, handler: { action in

            }))
        } else if presenter?.listType == .friendRequests {
            alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Recusar", style: .default, handler: { action in

            }))
        } else if presenter?.listType == .groupRequests {
            alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Recusar", style: .destructive, handler: { action in

            }))
        } else if presenter?.listType == .groupMembers && presenter?.isGroupAdmin ?? false {
            alert.addAction(UIAlertAction(title: "Remover do Grupo", style: .destructive, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Bloquear do Grupo", style: .destructive, handler: { action in

            }))
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.fetchData()
        tableView.dataSource = presenter?.dataSource
    }
    
    func finishedFetching() {
        if presenter?.dataSource.items.isEmpty ?? true {
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
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
}
