//
//  FriendListTableViewCell.swift
//  CaraLivro
//
//  Created by Luan Lima on 30/05/18.
//  Copyright © 2018 Luan Lima. All rights reserved.
//

import UIKit

@objc protocol FriendListViewActions: class {
    @objc optional func didSelectedFriend(_ sender: FriendListTableViewCell)
}

enum ListType {
    case friends, groups, friendRequests, groupRequests, groupMembers
}

final class FriendListTableViewCell: UITableViewCell, UITableViewContent {
    
    weak var presenter: FriendListTableViewCellPresenter?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert(postID: 0, postOwnerID: presenter?.user?.idUserProfile ?? 0)
    }

    @IBAction func didTouchColumn(_ sender: Any) {
        self.sendAction(#selector(FriendListViewActions.didSelectedFriend(_:)), sender: self)
    }

    func load(presenter: FriendListTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }
    
    func configureView() {
        userName.text = presenter?.userName
        userImage.image = UIImage(named: presenter?.userImage ?? "profilePic")
        if presenter?.listType == .groups {
            userImage.isHidden = true
        }
    }
}

final class FriendListTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FriendListTableViewCell>(presenter: self)
    }

    var user: UserDetails?
    var userName: String?
    var userImage: String?
    var listType: ListType?
    var group: GroupsDetails?
    var view: FriendListTableViewCellConform?
    
    init(userDetails: UserDetails, view: FriendListTableViewCellConform, list: ListType) {
        user = userDetails
        userName = (userDetails.FirstName ?? "") + " " + (userDetails.LastName ?? "")
        userImage = userDetails.ProfilePicture
        listType = list
        self.view = view
    }

    init(groupDetails: GroupsDetails, view: FriendListViewController) {
        userName = groupDetails.Name
        listType = .groups
        group = groupDetails
        self.view = view
    }
}
