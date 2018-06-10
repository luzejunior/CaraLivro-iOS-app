//
//  GroupViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 10/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

final class GroupViewControllerPresenter {
    var dataSource = GenericDataSource()
    private var view: GroupViewController?
    var currentGroup: GroupsDetails?
    var isAdm = false
    var isMember = false

    init(with view: GroupViewController, group: GroupsDetails) {
        self.view = view
        currentGroup = group
    }

    func getGroupAdmin() {
        let stringURL = "group/" + String(describing: currentGroup?.idGroups ?? 0) + "/admins"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.async {
                for user in users {
                    if user.idUserProfile == currentUserInUse?.idUserProfile {
                        self.isAdm = true
                    }
                }
            }
        }
    }

    func getGroupUser() {
        let stringURL = "group/" + String(describing: currentGroup?.idGroups ?? 0) + "/members"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.async {
                for user in users {
                    if user.idUserProfile == currentUserInUse?.idUserProfile {
                        self.isMember = true
                    }
                }
            }
        }
        self.getGroupAdmin()
    }

    func getPosts() {
        let stringURL = "group/" + String(describing: currentGroup?.idGroups ?? 0) + "/mural/posts"
        print(stringURL)
        getDataFromServer(path: stringURL) { (posts: [TextPost]) in
            DispatchQueue.main.async {
                self.configureTableView(posts: posts)
            }
        }
    }

    func fetchData() {
        getGroupUser()
        getPosts()
    }

    func configureTableView(posts: [TextPost]) {
        dataSource.items.removeAll()
        for item in posts {
            let tableContent = FeedTableViewCellPresenter(textPost: item, view: view!)
            dataSource.items.append(tableContent)
        }
        view?.finishedFetching()
        view?.configureGroup()
    }
}

final class GroupViewController: UIViewController, Storyboarded, MoreOptionsConform {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    @IBOutlet weak var userButton: UIButton!

    var presenter: GroupViewControllerPresenter?
    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = presenter?.dataSource
        presenter?.fetchData()
        // Do any additional setup after loading the view.
    }

    func openCommentaries(postID: Int, postOwnerID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID, postOwnerID: postOwnerID)
    }

    func presentUIAlert() {
        if presenter?.isAdm ?? false {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)

            alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in

            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        }
    }

    @IBAction func didTouchUserList(_ sender: Any) {

    }

    @IBAction func didTouchEntrarButton(_ sender: Any) {
        
    }

    @IBAction func didTouchPostIntoGroup(_ sender: Any) {
        coordinator?.didTouchPostButton(postGroupID: presenter?.currentGroup?.idGroups ?? 0)
    }

    func configureGroup() {
        groupName.text = presenter?.currentGroup?.Name
        groupDescription.text = presenter?.currentGroup?.Description
        if presenter?.isMember ?? false {
            userButton.isHidden = true
        }
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}
