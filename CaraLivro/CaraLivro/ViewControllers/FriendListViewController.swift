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
    var listType: ListType?

    init(with view: FriendListViewController, listType: ListType) {
        self.view = view
        self.listType = listType

    }
    
    func fetchData() {
        dataSource.items.removeAll()
        if listType == .friends {
            for item in testUsers {
                let tableContent1 = FriendListTableViewCellPresenter(userDetails: item, view: view!)
                dataSource.items.append(tableContent1)
            }
        }
        if listType == .groups {
            for item in groupList {
                let tableContent1 = FriendListTableViewCellPresenter(groupDetails: item, view: view!)
                dataSource.items.append(tableContent1)
            }
        }
        view?.finishedFetching()
    }
}

// CONTROLLER
final class FriendListViewController: UIViewController, Storyboarded, FriendListTableViewCellConform {
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    
    var presenter: FriendListViewControllerPresenter?
    var coordinator: Coordinator?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenter?.listType == .friends {
            navigationController?.navigationBar.topItem?.title = "Friends List"
        } else {
            navigationController?.navigationBar.topItem?.title = "Groups List"
        }
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
        tableView.dataSource = presenter?.dataSource
    }
    
    func finishedFetching() {
        tableView.reloadData()
    }
    
    func RegisterCells() {
        tableView.register(FriendListTableViewCell.self)
    }
}
