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

    init(with view: FriendListViewController) {
        self.view = view
    }
    
    func fetchData() {
        dataSource.items.removeAll()
        for item in testUsers {
            let tableContent1 = FriendListTableViewCellPresenter(userDetails: item)
            dataSource.items.append(tableContent1)
        }
        view?.finishedFetching()
    }
}

// CONTROLLER
final class FriendListViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    
    var presenter: FriendListViewControllerPresenter?
    var coordinator: Coordinator?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = FriendListViewControllerPresenter(with: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Friends List"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData()
        tableView.dataSource = presenter?.dataSource
    }
    
    func finishedFetching() {
        tableView.reloadData()
    }
    
    func RegisterCells() {
        tableView.register(FriendListTableViewCell.self)
    }
}
