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
            if self.profileStatus != .uself {
                self.getRequestedMe()
            }
            if self.profileStatus != .requestedme {
                self.getFriendship()
            }
        }
    }

    func configureTableView(posts: [TextPost]) {
        dataSource.items.removeAll()
        for item in posts {
            let tableContent1 = FeedTableViewCellPresenter(textPost: item, view: view!)
            dataSource.items.append(tableContent1)
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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var friendButton: UIButton!

    @IBAction func friendListButton(_ sender: Any) {
        coordinator?.didTouchFriendListButton()
    }

    @IBAction func groupsButton(_ sender: Any) {
        coordinator?.didTouchGroupsButton()
    }

    @IBAction func postButton(_ sender: Any) {
        coordinator?.didTouchPostButton(postUserID: presenter?.currentUser?.idUserProfile ?? 0)
    }
    
    public func presentUIAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in
            
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

    func openCommentaries(postID: Int, postOwnerID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID, postOwnerID: postOwnerID)
    }

    func configureUser() {
        userImage.image = UIImage(named: presenter?.currentUser?.ProfilePicture ?? "profilePic")
        userName.text = (presenter?.currentUser?.FirstName ?? "") + " " + (presenter?.currentUser?.LastName ?? "")
        userEmail.text = presenter?.currentUser?.Email ?? ""
        friendButton.isHidden = presenter?.profileStatus == .uself ? true : false
    }

    func configureAddButton() {
        if presenter?.profileStatus == .requested || presenter?.profileStatus == .requestedme {
            friendButton.setImage(UIImage(named: "requests_icon"), for: .normal)
        } else if presenter?.profileStatus == .friend {
            friendButton.setImage(UIImage(named: "add_feeling_btn"), for: .normal)
        } else {
            friendButton.setImage(UIImage(named: "tag_friend_btn"), for: .normal)
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
