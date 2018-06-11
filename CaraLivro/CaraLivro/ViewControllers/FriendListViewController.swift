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
    var listAll = false
    var isGroupAdmin = false

    init(with view: FriendListViewController, listType: ListType, currentUserID: Int) {
        self.view = view
        self.currentUserID = currentUserID
        self.listType = listType
        if currentUserID == -1 {
            listAll = true
        }
    }

    init(with view: FriendListViewController, listType: ListType, currentGroupID: Int) {
        self.view = view
        self.currentGroupID = currentGroupID
        self.listType = listType
        if currentGroupID == -1 {
            listAll = true
        }
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
        } else if listType == .blockedUsers {
            let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/blocks"
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

    func acceptFriendRequest(_ friendID: Int) {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/" + String(describing: friendID ) + "/accept"
        getDataFromServer(path: stringURL) { (netMessage: networkingMessage) in
            DispatchQueue.main.async {
                if netMessage.sucess {
                    self.fetchData()
                }
            }
        }
    }

    func declineFriendRequest(_ friendID: Int) {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/" + String(describing: friendID ) + "/deny"
        getDataFromServer(path: stringURL) { (netmessage: networkingMessage) in
            DispatchQueue.main.async {
                if netmessage.sucess {
                    self.fetchData()
                }
            }
        }
    }

    func unmakeFrienship(_ friendID: Int) {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/unfriend/" + String(describing: friendID )
        getDataFromServer(path: stringURL) { (netmessage: networkingMessage) in
            DispatchQueue.main.async {
                if netmessage.sucess {
                    self.fetchData()
                }
            }
        }
    }

    func blockUser(_ friendID: Int) {

    }

    func acceptGroupRequest(_ userID: Int) {

    }

    func declineGroupRequest(_ userID: Int) {

    }

    func eraseUserFromGroup(_ userID: Int) {

    }

    func blockUserFromGroup(_ userID: Int) {

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
                self.presenter?.unmakeFrienship(postOwnerID)
            }))
            alert.addAction(UIAlertAction(title: "Bloquear", style: .destructive, handler: { action in
                self.presenter?.blockUser(postOwnerID)
            }))
        } else if presenter?.listType == .friends && presenter?.listAll == true {
            alert.addAction(UIAlertAction(title: "Denunciar", style: .destructive, handler: { action in
                let alert = UIAlertController(title: "Denunciar", message: "Obrigado pela denuncia! :)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }))
        } else if presenter?.listType == .friendRequests {
            alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in
                self.presenter?.acceptFriendRequest(postOwnerID)
            }))
            alert.addAction(UIAlertAction(title: "Recusar", style: .default, handler: { action in
                self.presenter?.declineFriendRequest(postOwnerID)
            }))
        } else if presenter?.listType == .groupRequests {
            alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in
                self.presenter?.acceptGroupRequest(postOwnerID)
            }))
            alert.addAction(UIAlertAction(title: "Recusar", style: .destructive, handler: { action in
                self.presenter?.declineGroupRequest(postOwnerID)
            }))
        } else if presenter?.listType == .groupMembers && presenter?.isGroupAdmin ?? false {
            alert.addAction(UIAlertAction(title: "Remover do Grupo", style: .destructive, handler: { action in
                self.presenter?.eraseUserFromGroup(postOwnerID)
            }))
            alert.addAction(UIAlertAction(title: "Bloquear do Grupo", style: .destructive, handler: { action in
                self.presenter?.blockUserFromGroup(postOwnerID)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.fetchData()
        tableView.dataSource = presenter?.dataSource
    }

    @objc func listAll() {
        presenter?.listAll = true
        presenter?.fetchData()
    }
    
    func finishedFetching() {
        if presenter?.dataSource.items.isEmpty ?? true {
            messageLabel.isHidden = false
            tableView.isHidden = true
            tableView.reloadData()
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
        } else {
            coordinator?.didTouchProfileButton(userToDisplay: (sender.presenter?.user)!)
        }
    }
}
