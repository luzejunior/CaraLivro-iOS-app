//
//  CommentTableViewCell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 06/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit
import StringStylizer

@objc protocol CommentTableViewCellActions: class {
    @objc optional func didSelectedCommentarie(_ sender: CommentTableViewCell)
}

final class CommentTableViewCell: UITableViewCell, UITableViewContent {

    weak var presenter: CommentTableViewCellPresenter?

    @IBOutlet weak var commentarieText: UILabel!
    @IBOutlet weak var showCommentsButton: UILabel!

    func load(presenter: CommentTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }

    func configureView() {
        self.showCommentsButton.text = nil
        let text = (presenter?.userName?.stylize().font(.Helvetica_Bold).color(UIColor.black).size(13.0).attr)! + ": ".stylize().font(.Helvetica_Bold).color(UIColor.black).size(11.0).attr + (presenter?.commentText?.stylize().font(.Helvetica).color(UIColor.darkGray).size(13.0).attr)!
        commentarieText.attributedText = text
        if presenter?.isResponse ?? false {
            self.showCommentsButton.text = nil
        } else if presenter?.comment?.NumberOfResponses ?? 0 > 0 {
            self.showCommentsButton.attributedText = "Ver respostas".stylize().font(.Helvetica_Bold).color(UIColor.black).size(13.0).attr
        }
    }

    @IBAction func didTouchShowResponses(_ sender: Any) {
        self.sendAction(#selector(CommentTableViewCellActions.didSelectedCommentarie(_:)), sender: self)
    }
}

final class CommentTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<CommentTableViewCell>(presenter: self)
    }

    var userID: Int?
    var userName: String?
    var commentText: String?
    var comment: Comments?
    var isResponse: Bool?

    init(comment: Comments, isResponse: Bool) {
        userID = comment.UserProfile_idUserProfile_commenter
        for user in apiUsers {
            if user.idUserProfile == comment.UserProfile_idUserProfile_commenter {
                userName = (user.FirstName ?? "") + " " + (user.LastName ?? "")
            }
        }
        commentText = comment.text ?? ""
        self.isResponse = isResponse
        self.comment = comment
    }

    init(response: Responses) {
        userID = response.UserProfile_idUserProfile_responder
        for user in apiUsers {
            if user.idUserProfile == userID {
                userName = (user.FirstName ?? "") + " " + (user.LastName ?? "")
            }
        }
        commentText = response.text ?? ""
    }

}
