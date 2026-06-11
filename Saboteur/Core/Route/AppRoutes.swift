//
//  Routes.swift
//  Saboteur
//
//  Created by Henrique Lima on 07/03/26.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case signIn
    case signUp
    case forgotPassword
    case home
    case profile
    case settings
    case termsOfUse
    case adminManageReports
    case adminManageTasks
    case detail(id: String)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .signIn:
            SignInView()
        case .signUp:
            SignUpView()
        case .forgotPassword:
            ForgotPasswordView()
        case .home:
            Text("")
        case .profile:
            Text("")
        case .settings:
            Text("")
        case .termsOfUse:
            TermsOfUseView()
        case .adminManageReports:
            AdminManageReportsView()
        case .adminManageTasks:
            AdminManageTasksView()
        case .detail(let id):
            Text("")
        }
    }
}
