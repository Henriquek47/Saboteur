//
//  AppRouter.swift
//  Saboteur
//
//  Created by Henrique Lima on 01/04/26.
//

import Foundation
import SwiftUI

@Observable
class AppRouter {
    var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pushReplacement(_ route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    func replaceAll(with route: AppRoute) {
        path = NavigationPath()
        path.append(route)
    }
    
    
    func pop() {
        path.removeLast()
    }
}
