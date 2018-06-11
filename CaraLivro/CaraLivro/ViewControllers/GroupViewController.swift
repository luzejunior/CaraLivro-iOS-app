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
    var isRequested = false

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

    func getRequested() {
        let stringURL = "group/" + String(describing: currentGroup?.idGroups ?? 0) + "/requests/pending"
        getDataFromServer(path: stringURL) { (users: [UserDetails]) in
            DispatchQueue.main.async {
                for user in users {
                    if user.idUserProfile == currentUserInUse?.idUserProfile {
                        self.isRequested = true
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
        getGroupAdmin()
        getPosts()
    }

    func configureTableView(posts: [TextPost]) {
        dataSource.items.removeAll()
        for item in posts {
            if item.Attachment_Path == nil {
                let tableContent = FeedTableViewCellPresenter(textPost: item, view: view!)
                dataSource.items.append(tableContent)
            } else {
                let tableContent = FeedImageTableViewCellPresenter(textPost: item, view: view!)
                dataSource.items.append(tableContent)
            }
        }
        view?.finishedFetching()
        view?.configureGroup()
    }

    func deletePost(postID: Int) {
        let stringURL = "post/" + String(describing: postID) + "/delete"
        getDataFromServer(path: stringURL) { (netMessage: networkingMessage) in
            DispatchQueue.main.async {
                if netMessage.sucess {
                    self.getPosts()
                }
            }
        }
    }
}

final class GroupViewController: UIViewController, Storyboarded, MoreOptionsConform {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var messageToUser: UILabel!

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

    func presentUIAlert(postID: Int, postOwnerID: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        if presenter?.isAdm ?? false {
            alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in
                self.presenter?.deletePost(postID: postID)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        } else {
            alert.addAction(UIAlertAction(title: "Denunciar", style: .destructive, handler: { action in
                let alert = UIAlertController(title: "Denunciar", message: "Obrigado pela denuncia! :)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        }
    }

    @IBAction func didTouchUserList(_ sender: Any) {
        coordinator?.didTouchGroupsMemberButton(currentGroupID: presenter?.currentGroup?.idGroups ?? 0, isGroupAdmin: presenter?.isAdm ?? false)
    }

    @IBAction func didTouchEntrarButton(_ sender: Any) {
        
    }

    @IBAction func didTouchPostIntoGroup(_ sender: Any) {
        if (presenter?.isMember ?? false) {
            coordinator?.didTouchPostButton(postGroupID: presenter?.currentGroup?.idGroups ?? 0)
        } else {
            let alert = UIAlertController(title: "OPS...", message: "Você ainda não é membro deste grupo!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func configureGroup() {
        groupName.text = presenter?.currentGroup?.Name
        groupDescription.text = presenter?.currentGroup?.Description
        if presenter?.isMember ?? false || presenter?.isRequested ?? false{
            userButton.isHidden = true
        }
        if presenter?.isAdm ?? false {
            let button1 = UIBarButtonItem(title: "Gerenciar", style: .plain, target: self, action: #selector(self.adminController))
            self.navigationItem.rightBarButtonItem  = button1
        }
    }

    @objc func adminController() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        alert.addAction(UIAlertAction(title: "Aceitar Usuários", style: .destructive, handler: { action in
            self.coordinator?.didTouchGroupsMemberRequestButton(currentGroupID: self.presenter?.currentGroup?.idGroups ?? 0)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }

    func finishedFetching() {
        if presenter?.isMember ?? false && !(presenter?.dataSource.items.isEmpty ?? true) {
            messageToUser.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            messageToUser.text = "Você não pode ver as mensagens deste grupo"
        }
        if presenter?.dataSource.items.isEmpty ?? false {
            messageToUser.text = "Ainda não existe posts neste grupo!"
        }
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}
