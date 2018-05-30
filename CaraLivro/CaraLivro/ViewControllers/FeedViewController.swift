//
//  ViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit

struct UserDetails {
    var userName: String?
    var userImage: String?
    var textContent: String?

    init(name: String, content: String, imageName: String) {
        userName = name
        userImage = imageName
        textContent = content
    }
}

protocol FeedViewControllerActions {
    func didTouchFriendList()
}

final class FeedViewControllerPresenter {
    var dataSource = GenericDataSource()
    private var view: FeedViewController?

    init(with view: FeedViewController) {
        self.view = view
    }

    func fetchData() {
        var user1 = UserDetails(name: "Luzenildo", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur cursus lacus in lorem tristique, tristique gravida ex pellentesque. Proin tristique, eros ut lobortis luctus, erat odio ultricies lacus, sit amet gravida est risus non turpis. Cras odio mi, sagittis at convallis non, ultricies eu nulla.", imageName: "luzenildo")
        var user2 = UserDetails(name: "Luan", content: "Quisque sit amet massa sem. Mauris euismod sit amet nibh volutpat commodo.", imageName: "luan")

        let tableContent1 = FeedTableViewCellPresenter(userDetails: user1)
        dataSource.items.append(tableContent1)
        let tableContent2 = FeedTableViewCellPresenter(userDetails: user2)
        dataSource.items.append(tableContent2)
        view?.finishedFetching()
    }
}

final class FeedViewController: UIViewController, Storyboarded {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.friendListButtonAction))
        self.navigationItem.rightBarButtonItem  = button1
        tableView.dataSource = presenter?.dataSource
    }

    @objc func friendListButtonAction() {
        coordinator?.didTouchFriendList()
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}

