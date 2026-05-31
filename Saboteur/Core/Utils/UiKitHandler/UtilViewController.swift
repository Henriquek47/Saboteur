//
//  UiViewController.swift
//  Saboteur
//
//  Created by Henrique Lima on 08/04/26.
//

import UIKit

final class UtilViewController {
    static let share = UtilViewController()
    
    private init() {}
    
    private var keyWindow: UIWindow? {
        // iOS 13+ approach: iterate through connected scenes
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?.keyWindow
        } else {
            // Fallback for older iOS versions
            return UIApplication.shared.keyWindow
        }
    }
    
    @MainActor
    func getTopViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? keyWindow?.rootViewController

        if let nav = controller as? UINavigationController {
            return getTopViewController(controller: nav.visibleViewController)
        }
        else if let tab = controller as? UITabBarController {
            return getTopViewController(controller: tab.selectedViewController)
        }
        else if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        
        return controller
    }
}
