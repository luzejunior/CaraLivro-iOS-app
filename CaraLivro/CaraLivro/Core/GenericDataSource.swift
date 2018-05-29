//
//  GenericDataSource.swift
//  CaraLivro
//
//  Created by Luzenildo Junior on 29/05/18.
//  Copyright © 2018 Luzenildo Junior. All rights reserved.
//
import UIKit

final class GenericDataSource: NSObject, UITableViewDataSource {

    var items: [UITableViewModels] = []

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.representable.identifier, for: indexPath)
        model.representable.update(view: cell)
        return cell
    }
}

protocol UITableViewModels {
    var representable: UITableViewRepresentable { get }
}

protocol UITableViewRepresentable {
    var tvClass: AnyClass { get }
    var identifier: String { get }
    func update(view: UIView)
}

protocol UITableViewContent {
    associatedtype Presenter
    func load(presenter: Presenter)
}

final class UITableViewContentAssembler<TVCell>: UITableViewRepresentable where TVCell : UITableViewContent, TVCell: UIView {
    let presenter: TVCell.Presenter
    let tvClass: AnyClass = TVCell.self

    init(presenter: TVCell.Presenter) {
        self.presenter = presenter
    }

    func update(view: UIView) {
        (view as? TVCell)?.load(presenter: presenter)
    }

    var identifier: String {
        return String(describing: tvClass)
    }
}

extension UITableView {
    func register(_ tvClass: AnyClass) {
        register(UINib(nibName: String(describing: tvClass.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: tvClass.self))
    }
}
