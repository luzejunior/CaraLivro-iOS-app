//
//  CommentTableViewCell.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 06/06/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//

import UIKit
import StringStylizer

final class CommentTableViewCell: UITableViewCell, UITableViewContent {

    weak var presenter: CommentTableViewCellPresenter?

    @IBOutlet weak var commentarieText: UILabel!

    func load(presenter: CommentTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }

    func configureView() {
        let text = (presenter?.userName?.stylize().font(.Helvetica_Bold).color(UIColor.black).size(13.0).attr)! + ": ".stylize().font(.Helvetica_Bold).color(UIColor.black).size(11.0).attr + (presenter?.commentText?.stylize().font(.Helvetica).color(UIColor.darkGray).size(13.0).attr)!
        commentarieText.attributedText = text
    }
}

final class CommentTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<CommentTableViewCell>(presenter: self)
    }

    var userID: Int?
    var userName: String?
    var commentText: String?

    init(comment: Comments) {
        userID = comment.idUserProfilePostCommenter

        for user in testUsers {
            if user.idUserProfile == userID {
                userName = user.FirstName
                break
            }
        }

        commentText = comment.commentText
    }

}
