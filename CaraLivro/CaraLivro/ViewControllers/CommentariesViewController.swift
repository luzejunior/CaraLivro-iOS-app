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
    var bottomConstraint: NSLayoutConstraint?

    let commentInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite um comentário"
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        button.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
        return button
    }()
    
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
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = presenter?.dataSource
        presenter?.fetchData()
        
        view.addSubview(commentInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: commentInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: commentInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: commentInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func commentButtonAction() {
        // Função pra inserir o comentário no BD.
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                // Ajustar a tableview quando o textField for selecionado.
            })
        }
    }
    
    func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        commentInputContainerView.addSubview(inputTextField)
        commentInputContainerView.addSubview(sendButton)
        commentInputContainerView.addSubview(topBorderView)
        
        commentInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        
        commentInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        commentInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        commentInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        commentInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
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
    var postOwnerID: Int?

    init(with view: CommentariesViewController, postID: Int, postOwnerID: Int) {
        self.view = view
        self.postID = postID
        self.postOwnerID = postOwnerID
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
