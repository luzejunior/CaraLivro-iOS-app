//
//  CommentariesViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

final class CommentariesViewController: UIViewController, Storyboarded {

    var presenter: CommentariesViewControllerPresenter?
    var string: NSAttributedString?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            RegisterCells()
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Comments"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = presenter?.dataSource
        presenter?.fetchData()
    }

    func RegisterCells() {
        tableView.register(CommentTableViewCell.self)
    }

    func loadCommentaries() {
        if presenter?.dataSource.items.isEmpty ?? true {
            messageLabel.isHidden = false
        } else {
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
}

final class CommentariesViewControllerPresenter {

    var dataSource = GenericDataSource()
    private var view: CommentariesViewController?
    var postID: Int?

    init(with view: CommentariesViewController, postID: Int) {
        self.view = view
        self.postID = postID
    }

    func fetchData() {
        dataSource.items.removeAll()
        for comments in testComments {
            if comments.idPost == postID {
                let tableContent = CommentTableViewCellPresenter(comment: comments)
                dataSource.items.append(tableContent)
            }
        }
        view?.loadCommentaries()
    }
}
