//
//  CommentariesViewController.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 01/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import Foundation
import UIKit

enum ViewType {
    case commentaries, responses
}

// PRESENTER
final class CommentariesViewControllerPresenter {
    
    var dataSource = GenericDataSource()
    private var view: CommentariesViewController?
    var postID: Int?
    var postOwnerID: Int?
    var viewType: ViewType?
    var commentToResponse: Comments?
    var commentID = [Int]()
    var responsesID = [Int]()
    
    init(with view: CommentariesViewController, postID: Int, postOwnerID: Int, viewType: ViewType) {
        self.view = view
        self.postID = postID
        self.postOwnerID = postOwnerID
        self.viewType = viewType
    }

    init(with view: CommentariesViewController, comment: Comments, viewType: ViewType) {
        self.view = view
        self.viewType = viewType
        commentToResponse = comment
    }
    
    func fetchData() {
        dataSource.items.removeAll()
        commentID.removeAll()
        let stringURL = "post/" + String(describing: postID ?? 0) + "/comments"
        getDataFromServer(path: stringURL) { (posts: [Comments]) in
            DispatchQueue.main.async {
                self.configureTableView(posts: posts)
            }
        }
    }

    func fetchResponses() {
        dataSource.items.removeAll()
        responsesID.removeAll()
        let tableContent = CommentTableViewCellPresenter(comment: commentToResponse!, isResponse: true)
        dataSource.items.append(tableContent)
        let stringURL = "comments/" + String(describing: commentToResponse?.idComments ?? 0) + "/responses"
        getDataFromServer(path: stringURL) { (posts: [Responses]) in
            DispatchQueue.main.async {
                self.configureTableView(posts: posts)
            }
        }
    }
    
    func configureTableView(posts: [Comments]) {
        for item in posts {
            commentID.append(item.idComments ?? 0)
            let tableContent1 = CommentTableViewCellPresenter(comment: item, isResponse: false)
            dataSource.items.append(tableContent1)
        }
        view?.loadCommentaries()
    }

    func configureTableView(posts: [Responses]) {
        for item in posts {
            responsesID.append(item.idResponses ?? 0)
            let tableContent1 = CommentTableViewCellPresenter(response: item)
            dataSource.items.append(tableContent1)
        }
        view?.loadCommentaries()
    }

    func deleteCommentarie(_ indexPath: Int) {
        let stringURL = "post/" + String(describing: postID ?? 0) + "/comments/" + String(describing: commentID[indexPath]) + "/delete"
        getDataFromServer(path: stringURL) { (response: networkingMessage) in
            DispatchQueue.main.async {
                if response.sucess {
                    self.fetchData()
                }
            }
        }
    }

    func deleteResponse(_ indexPath: Int) {
        let stringURL = "comments/" + String(describing: commentToResponse?.idComments ?? 0) + "/responses/" + String(describing: responsesID[(indexPath-1)]) + "/delete"
        getDataFromServer(path: stringURL) { (response: networkingMessage) in
            DispatchQueue.main.async {
                if response.sucess {
                    self.fetchResponses()
                }
            }
        }
    }
}

// CONTROLLER
final class CommentariesViewController: UIViewController, Storyboarded, CommentTableViewCellActions, UITableViewDelegate {

    var presenter: CommentariesViewControllerPresenter?
    var string: NSAttributedString?
    var bottomConstraint: NSLayoutConstraint?
    var coordinator: MainCoordinator?

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
        if presenter?.viewType == .commentaries {
            navigationController?.navigationBar.topItem?.title = "COMENTÁRIOS"
        } else {
            navigationController?.navigationBar.topItem?.title = "RESPOSTAS"
        }
        if presenter?.viewType == .commentaries {
            presenter?.fetchData()
        } else {
            presenter?.fetchResponses()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = presenter?.dataSource
        
        view.addSubview(commentInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: commentInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: commentInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: commentInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        if presenter?.viewType == .commentaries {
            presenter?.fetchData()
        } else {
            presenter?.fetchResponses()
        }
        refreshControl.endRefreshing()
    }

    @objc func commentButtonAction() {
        if presenter?.viewType == .commentaries {
            let comment = CommentInPost(user_id_poster: self.presenter?.postOwnerID ?? 0, user_id_commenter: currentUserInUse?.idUserProfile ?? 0, text: inputTextField.text ?? "")
            let stringURL = "post/" + String(describing: self.presenter?.postID ?? 0) + "/comment"
            postDataToServer(object: comment, path: stringURL) {
                DispatchQueue.main.async {
                    self.presenter?.fetchData()
                }
            }
            self.inputTextField.text = ""
        } else {
            let comment = CommentResponse(user_id_poster: self.presenter?.commentToResponse?.Post_UserProfile_idUserProfile_postOwner ?? 0, user_id_commenter: self.presenter?.commentToResponse?.UserProfile_idUserProfile_commenter ?? 0, user_id_responder: currentUserInUse?.idUserProfile ?? 0,text: inputTextField.text ?? "")
            let stringURL = "post/" + String(describing: self.presenter?.commentToResponse?.Post_idPost ?? 0) + "/comment/" + String(describing: self.presenter?.commentToResponse?.idComments ?? 0) + "/respond"
            postDataToServer(object: comment, path: stringURL) {
                DispatchQueue.main.async {
                    self.presenter?.fetchResponses()
                }
            }
            self.inputTextField.text = ""
        }
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
            messageLabel.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }

    func didSelectedCommentarie(_ sender: CommentTableViewCell) {
        if presenter?.viewType == .commentaries {
            let commentarie = sender.presenter?.comment
            coordinator?.didTouchOpenResponsesButton(comment: commentarie!)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var isTopComment = false
        if indexPath.row == 0 && self.presenter?.viewType == .responses {
            isTopComment = true
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Apagar") { (action, indexPath) in
            if self.presenter?.viewType == .commentaries && !(isTopComment) {
                self.presenter?.deleteCommentarie(indexPath.row)
            } else {
                self.presenter?.deleteResponse(indexPath.row)
            }
        }

        if isTopComment {
            return []
        }
        return [delete]
    }
}
