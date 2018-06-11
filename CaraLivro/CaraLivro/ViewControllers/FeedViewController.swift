//
//  ViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

// PRESENTER
final class FeedViewControllerPresenter {
    var dataSource = GenericDataSource()
    private var view: FeedViewController?

    init(with view: FeedViewController) {
        self.view = view
    }

    func fetchData() {
        let stringURL = "user/" + String(describing: currentUserInUse?.idUserProfile ?? 0) + "/feed"
        getDataFromServer(path: stringURL) { (posts: [TextPost]) in
            DispatchQueue.main.async {
                self.configureTableView(posts: posts)
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
    }
}

// CONTROLLER
final class FeedViewController: UIViewController, Storyboarded, MoreOptionsConform, FeedTableViewCellActions {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }

    var presenter: FeedViewControllerPresenter?
    var coordinator: FeedViewControllerActions?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = FeedViewControllerPresenter(with: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Feed"
        presenter?.fetchData()
    }
    
    public func presentUIAlert(postID: Int, postOwnerID: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)

        if postOwnerID == currentUserInUse?.idUserProfile ?? 0 {
            alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in
                self.presenter?.deletePost(postID: postID)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Denunciar", style: .default, handler: { action in
                let alert = UIAlertController(title: "Denunciar", message: "Obrigado pela denuncia! :)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.allOptionsButton))
        self.navigationItem.rightBarButtonItem  = button1
        let button2 = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(self.logOut))
        self.navigationItem.leftBarButtonItem = button2
        tableView.dataSource = presenter?.dataSource
    }

    @objc func allOptionsButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Blocked users", style: .default, handler: { action in
            // Blocked users
        }))
        
        alert.addAction(UIAlertAction(title: "Friend requests", style: .default, handler: { action in
            // Friend requests
        }))
        alert.addAction(UIAlertAction(title: "Profile", style: .default, handler: { action in
            self.friendListButtonAction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    @objc func logOut() {
        coordinator?.logOut()
    }

    func openCommentaries(postID: Int, postOwnerID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID, postOwnerID: postOwnerID)
    }

    @objc func friendListButtonAction() {
        coordinator?.didTouchProfileButton(userToDisplay: currentUserInUse!)
    }

    func didTouchUser(_ sender: FeedTableViewCell) {
        coordinator?.presentUserPage(user: (sender.presenter?.posterUser)!)
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
        tableView.register(FeedImageTableViewCell.self)
    }
}

