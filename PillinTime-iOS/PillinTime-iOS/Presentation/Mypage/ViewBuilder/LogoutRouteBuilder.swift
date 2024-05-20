//
//  LogoutRouteBuilder.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/19/24.
//

import SwiftUI

import LinkNavigator

struct LogoutRouteBuilder: RouteBuilder {
    var matchPath: String { "logout" }
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                LogoutView(navigator: navigator).navigationBarHidden(true)
            }
        }
    }
}
