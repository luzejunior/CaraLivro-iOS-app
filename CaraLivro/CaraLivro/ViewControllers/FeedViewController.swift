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
            let tableContent1 = FeedTableViewCellPresenter(textPost: item)
            dataSource.items.append(tableContent1)
        }
        view?.finishedFetching()
    }
}

// CONTROLLER
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData()
        let button1 = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.friendListButtonAction))
        self.navigationItem.rightBarButtonItem  = button1
        tableView.dataSource = presenter?.dataSource
    }

    @objc func friendListButtonAction() {
        coordinator?.didTouchProfileButton(userToDisplay: testUsers[0])
    }

    func finishedFetching() {
        tableView.reloadData()
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}

