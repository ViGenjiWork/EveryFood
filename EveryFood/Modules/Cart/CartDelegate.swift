//
//  CartDelegate.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 24.06.2022.
//

import Foundation
import UIKit

final class CartDelegate: NSObject, UITableViewDelegate {
    private enum Metrics {
        static let heightForHeader: CGFloat = 10
        static let heightForRow: CGFloat = 100
    }
    
    var didDeleteItemAtIndexPathHandler: ((IndexPath)->())?
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Metrics.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacingView = UIView()
        spacingView.backgroundColor = UIColor.clear
        return spacingView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.heightForRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            self?.didDeleteItemAtIndexPathHandler?(indexPath)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: UITableView.RowAnimation.automatic)
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        delete.backgroundColor = .designSystemMainBG
        actions.append(delete)

        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}
