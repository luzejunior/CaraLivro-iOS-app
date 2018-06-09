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
    case uself, other, friend
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
        }
    }

    func configureTableView(posts: [TextPost]) {
        dataSource.items.removeAll()
        for item in posts {
            let tableContent1 = FeedTableViewCellPresenter(textPost: item, view: view!)
            dataSource.items.append(tableContent1)
        }
//        for item in imagePosts {
//            let tableContent = FeedImageTableViewCellPresenter(textPost: item, view: view!)
//            dataSource.items.append(tableContent)
//        }
        view?.finishedFetching()
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
        alert.addAction(UIAlertAction(title: "Denunciar", style: .default, handler: { action in
            
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

    func openCommentaries(postID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID)
    }

    func configureUser() {
        userImage.image = UIImage(named: presenter?.currentUser?.ProfilePicture ?? "profilePic")
        userName.text = (presenter?.currentUser?.FirstName ?? "") + " " + (presenter?.currentUser?.LastName ?? "")
        userEmail.text = presenter?.currentUser?.Email ?? ""
    }

    func finishedFetching() {
            tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
        tableView.register(FeedImageTableViewCell.self)
    }
}
