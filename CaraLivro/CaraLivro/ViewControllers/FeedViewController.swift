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

final class ViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            //tableView.estimatedRowHeight = 86.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }

    var dataSource = GenericDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        var user1 = UserDetails(name: "Luzenildo", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur cursus lacus in lorem tristique, tristique gravida ex pellentesque. Proin tristique, eros ut lobortis luctus, erat odio ultricies lacus, sit amet gravida est risus non turpis. Cras odio mi, sagittis at convallis non, ultricies eu nulla.", imageName: "luzenildo")
        var user2 = UserDetails(name: "Luan", content: "Quisque sit amet massa sem. Mauris euismod sit amet nibh volutpat commodo.", imageName: "luan")

        let tableContent1 = FeedTableViewCellPresenter(userDetails: user1)
        dataSource.items.append(tableContent1)
        let tableContent2 = FeedTableViewCellPresenter(userDetails: user2)
        dataSource.items.append(tableContent2)

        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func RegisterCells() {
        tableView.register(FeedTableViewCell.self)
    }
}

