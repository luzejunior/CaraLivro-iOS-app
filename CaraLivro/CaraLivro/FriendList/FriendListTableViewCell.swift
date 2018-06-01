//
//  FriendListTableViewCell.swift
//  CaraLivro
//
//  Created by Luan Lima on 30/05/18.
//  Copyright © 2018 Luan Lima. All rights reserved.
//

import UIKit

enum ListType {
    case friends, groups
}

final class FriendListTableViewCell: UITableViewCell, UITableViewContent {
    
    weak var presenter: FriendListTableViewCellPresenter?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func moreOptions(_ sender: Any) {
        presenter?.view?.presentUIAlert()
    }
    
    func load(presenter: FriendListTableViewCellPresenter) {
        self.presenter = presenter
        configureView()
    }
    
    func configureView() {
        userName.text = presenter?.userName
        userImage.image = UIImage(named: presenter?.userImage ?? "")
        if presenter?.listType == .groups {
            userImage.isHidden = true
        }
    }
}

final class FriendListTableViewCellPresenter: UITableViewModels {
    var representable: UITableViewRepresentable {
        return UITableViewContentAssembler<FriendListTableViewCell>(presenter: self)
    }
    
    var userName: String?
    var userImage: String?
    var listType: ListType?
    var view: FriendListViewController?
    
    init(userDetails: UserDetails, view: FriendListViewController) {
        userName = userDetails.userName
        userImage = userDetails.userImage
        listType = .friends
        self.view = view
    }

    init(groupDetails: GroupsDetails, view: FriendListViewController) {
        userName = groupDetails.groupName
        listType = .groups
        self.view = view
    }
}
