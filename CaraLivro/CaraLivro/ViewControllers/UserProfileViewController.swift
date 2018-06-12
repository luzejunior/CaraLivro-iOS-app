//
//  UserProfileViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 30/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

enum ProfileType {
    case uself, other, friend, requested, requestedme
}

// PRESENTER
final class UserProfileViewControllerPresenter {
    var dataSource = GenericDataSource()
    var currentUser: UserDetails?
    private var view: UserProfileViewController?
    var profileStatus: ProfileType?

    init(with view: UserProfileViewController, currentUser: UserDetails) {
        self.view = view
        self.currentUser = currentUser
        setProfileStatus()
    }

    func setProfileStatus() {
        profileStatus = currentUser?.idUserProfile != currentUserInUse?.idUserProfile ? .other : .uself
    }

    func fetchData() {
        if self.profileStatus != .uself {
            self.getRequestedMe()
        }
        if self.profileStatus != .requestedme {
            self.getFriendship()
        }
        var stringURL: String
        if profileStatus == .uself {
            stringURL = "user/" + String(describing: currentUser?.idUserProfile ?? 0) + "/mural/posts"
        } else {
            stringURL = "user/" + String(describing: currentUser?.idUserProfile ?? 0) + "/mural/posts"
        }
        getDataFromServer(path: stringURL) { (posts: [TextPost]) in
            DispatchQueue.main.async {
                self.configureTableView(posts: posts)
            }
        }
    }

    func configureTableView(posts: [TextPost]) {
        dataSource.items.removeAll()
        for item in posts {
            if item.Attachment_Path == nil {
                if item.Visibility == 0 && (profileStatus != .friend && profileStatus != .uself) {

                } else {
                    let tableContent = FeedTableViewCellPresenter(textPost: item, view: view!)
                    dataSource.items.append(tableContent)
                }
            } else {
                if item.Visibility == 0 && (profileStatus != .friend || profileStatus != .uself) {

                } else {
                    let tableContent = FeedImageTableViewCellPresenter(textPost: item, view: view!)
                    dataSource.items.append(tableContent)
                }
            }
        }
        view?.finishedFetching()
    }

    func getRequestedMe() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/received"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.async {
                for user in users {
                    if user.idUserProfile == self.currentUser?.idUserProfile {
                        self.profileStatus = .requestedme
                        self.view?.configureAddButton()
                    }
                }
            }
        }
    }

    func getFriendship() {
        let stringURL = "user/" + String(describing: currentUser?.idUserProfile ?? 0) + "/friends"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.sync {
                for user in users {
                    if user.idUserProfile == currentUserInUse?.idUserProfile {
                        self.profileStatus = .friend
                        self.view?.configureAddButton()
                    }
                }
                if self.profileStatus != .friend {
                    self.getRequestedFriend()
                }
            }
        }
    }

    func getRequestedFriend() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/sent"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.async {
                for user in users {
                    if user.idUserProfile == self.currentUser?.idUserProfile {
                        self.profileStatus = .requested
                    }
                }
                self.view?.configureAddButton()
            }
        }
    }

    func cancelRequest() {
        let json = FriendshipRequestJson(user_requester_id: currentUserInUse?.idUserProfile ?? 0)
        let stringURL = "user/" + String(describing: currentUser?.idUserProfile ?? 0) + "/request/cancel"
        postDataToServer(object: json, path: stringURL) {
            DispatchQueue.main.async {
                self.profileStatus = .other
                self.view?.configureAddButton()
            }
        }
    }

    func requesFriendship() {
        let json = FriendshipRequestJson(user_requester_id: currentUserInUse?.idUserProfile ?? 0)
        let stringURL = "user/" + String(describing: currentUser?.idUserProfile ?? 0) + "/request"
        postDataToServer(object: json, path: stringURL) {
            DispatchQueue.main.async {
                self.profileStatus = .requested
                self.view?.configureAddButton()
            }
        }
    }

    func acceptFriendRequest() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/" + String(describing: currentUser?.idUserProfile ?? 0) + "/accept"
        getDataFromServer(path: stringURL) { (netMessage: networkingMessage) in
            DispatchQueue.main.async {
                if netMessage.sucess {
                    self.profileStatus = .friend
                    self.view?.configureAddButton()
                }
            }
        }
    }

    func declineFriendRequest() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/requests/" + String(describing: currentUser?.idUserProfile ?? 0) + "/deny"
        getDataFromServer(path: stringURL) { (netmessage: networkingMessage) in
            DispatchQueue.main.async {
                if netmessage.sucess {
                    self.profileStatus = .other
                    self.view?.configureAddButton()
                }
            }
        }
    }

    func unmakeFrienship() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/unfriend/" + String(describing: currentUser?.idUserProfile ?? 0)
        getDataFromServer(path: stringURL) { (netmessage: networkingMessage) in
            DispatchQueue.main.async {
                if netmessage.sucess {
                    self.profileStatus = .other
                    self.view?.configureAddButton()
                }
            }
        }
    }

    func deletePost(postID: Int) {
        let stringURL = "post/" + String(describing: postID) + "/delete"
        getDataFromServer(path: stringURL) { (netMessage: networkingMessage) in
            DispatchQueue.main.async {
                if netMessage.sucess {
                    self.fetchData()
                }
            }
        }
    }
}

// CONTROLLER
final class UserProfileViewController: UIViewController, Storyboarded, MoreOptionsConform {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.cropAsCircleWithBorder(borderColor: UIColor.black, strokeWidth: 2.0)
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var friendButton: UIButton!

    @IBAction func friendListButton(_ sender: Any) {
        coordinator?.didTouchFriendListButton(currentUserID: presenter?.currentUser?.idUserProfile ?? 0)
    }

    @IBAction func groupsButton(_ sender: Any) {
        coordinator?.didTouchGroupsButton(currentUserID: presenter?.currentUser?.idUserProfile ?? 0)
    }

    @IBAction func postButton(_ sender: Any) {
        if presenter?.profileStatus == .friend || presenter?.profileStatus == .uself {
            coordinator?.didTouchPostButton(postUserID: presenter?.currentUser?.idUserProfile ?? 0)
        } else {
            let alert = UIAlertController(title: "OPS...", message: "Vocês ainda não são amigos!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func presentUIAlert(postID: Int, postOwnerID: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in
            self.presenter?.deletePost(postID: postID)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }

    public func presentFriendRequestUIAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        alert.addAction(UIAlertAction(title: "Aceitar", style: .destructive, handler: { action in
            self.presenter?.acceptFriendRequest()
        }))
        alert.addAction(UIAlertAction(title: "Recusar", style: .default, handler: { action in
            self.presenter?.declineFriendRequest()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }

    var presenter: UserProfileViewControllerPresenter?
    var coordinator: MainCoordinator?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "PERFIL"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = presenter?.dataSource
        configureUser()
        presenter?.fetchData()

        if presenter?.currentUser?.idUserProfile == currentUserInUse?.idUserProfile {
            let button1 = UIBarButtonItem(title: "More Options", style: .plain, target: self, action: #selector(self.moreOptionsButton))
            self.navigationItem.rightBarButtonItem  = button1
            button1.image = UIImage(named: "friends more options")
            button1.tintColor = .black
        }
    }

    @objc func moreOptionsButton() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
        
        let request = UIAlertAction(title: "Solicitações de Amizade", style: .default) { (action) in
            self.coordinator?.didTouchFriendRequestListButton(currentUserID: currentUserInUse?.idUserProfile ?? 0)
        }
        let requestIcon = UIImage(named: "friend request list")
        request.setValue(requestIcon, forKey: "image")
        request.setValue(0, forKey: "titleTextAlignment")
        request.setValue(UIColor.black, forKey: "titleTextColor")
        actionSheet.addAction(request)
        
        let blockedUsers = UIAlertAction(title: "Usuários Bloqueados", style: .default) { (action) in
            self.coordinator?.didTouchBlockedFriendsButton(currentUserID: currentUserInUse?.idUserProfile ?? 0)
        }
        let blockedUsersIcon = UIImage(named: "blocked user")
        blockedUsers.setValue(blockedUsersIcon, forKey: "image")
        blockedUsers.setValue(0, forKey: "titleTextAlignment")
        blockedUsers.setValue(UIColor.black, forKey: "titleTextColor")
        actionSheet.addAction(blockedUsers)
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        actionSheet.addAction(cancel)
    }

    func openCommentaries(postID: Int, postOwnerID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID, postOwnerID: postOwnerID)
    }

    func configureUser() {
        userImage.image = nil
        if presenter?.currentUser?.ProfilePicture == nil {
            userImage.image = UIImage(named: "profile pic")
        } else {
            userImage.kf.setImage(with: URL(string: presenter?.currentUser?.ProfilePicture ?? ""))
        }
        userName.text = (presenter?.currentUser?.FirstName ?? "") + " " + (presenter?.currentUser?.LastName ?? "")
        userEmail.text = presenter?.currentUser?.Email ?? ""
        friendButton.isHidden = presenter?.profileStatus == .uself ? true : false
    }

    func configureAddButton() {
        if presenter?.profileStatus == .requested || presenter?.profileStatus == .requestedme {
            friendButton.setImage(UIImage(named: "friend requested"), for: .normal)
        } else if presenter?.profileStatus == .friend {
            friendButton.setImage(UIImage(named: "friend accepted"), for: .normal)
        } else {
            friendButton.setImage(UIImage(named: "friend request open"), for: .normal)
        }
    }

    @IBAction func addFriendButtonAction(_ sender: Any) {
        if presenter?.profileStatus == .requested {
            presenter?.cancelRequest()
        } else if presenter?.profileStatus == .other {
            presenter?.requesFriendship()
        } else if presenter?.profileStatus == .requestedme {
            self.presentFriendRequestUIAlert()
        } else if presenter?.profileStatus == .friend {
            self.presenter?.unmakeFrienship()
        }
    }


    func finishedFetching() {
            tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
        tableView.register(FeedImageTableViewCell.self)
    }
}
