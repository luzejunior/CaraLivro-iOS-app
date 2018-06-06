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
        dataSource.items.removeAll()
        for item in testPosts {
            let tableContent1 = FeedTableViewCellPresenter(textPost: item, view: view!)
            dataSource.items.append(tableContent1)
        }
        for item in imagePosts {
            let tableContent = FeedImageTableViewCellPresenter(textPost: item, view: view!)
            dataSource.items.append(tableContent)
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
    }

    public func presentUIAlert () {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Apagar", style: .destructive, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Denunciar", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData()
        let button1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.friendListButtonAction))
        self.navigationItem.rightBarButtonItem  = button1
        tableView.dataSource = presenter?.dataSource
    }

    func openCommentaries(postID: Int) {
        coordinator?.didTouchCommentariesButton(postID: postID)
    }

    @objc func friendListButtonAction() {
        coordinator?.didTouchProfileButton(userToDisplay: testUsers[0])
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

