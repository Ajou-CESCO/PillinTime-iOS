//
//  AppDelegate.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 5/1/24.
//

import SwiftUI
import LinkNavigator
import Factory

/// 외부 의존성과 화면을 주입받은 navigator를 관리하는 타입입니다.
final class AppDelegate: NSObject {
    var navigator: LinkNavigator {
        LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
    }
}

extension AppDelegate: UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}
