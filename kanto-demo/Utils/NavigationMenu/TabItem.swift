//
//  TabItem.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import UIKit

enum TabItem: String, CaseIterable{
    case broadCast = "broadcast"
    case records = "records"
    case sing = "sing"
    case notifications = "notifications"
    case userconfig = "userconfig"
    
    var viewController: UIViewController {
        switch self {
        case .broadCast:
            return BroadCastViewController()
        case .records:
            return RecordsViewController()
        case .sing:
            return SingViewController()
        case .notifications:
            return NotificationsViewController()
        case .userconfig:
            return UserConfigViewController()
        }
    }
    
    var icon:UIImage? {
        switch self {
        case .broadCast:
            return UIImage(named: "broadcast")
        case .records:
            return UIImage(named: "reproduce")
        case .sing:
            return UIImage(named: "microphone")
        case .notifications:
            return UIImage(named: "bell")
        case .userconfig:
            return UIImage(named: "user")
        }
    }
    
    var displayTitle:String {
        return self.rawValue.capitalized(with: nil)
    }
    
}

