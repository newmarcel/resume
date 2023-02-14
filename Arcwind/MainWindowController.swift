//
//  MainWindowController.swift
//  Arcwind
//
//  Created by Marcel Dierkes on 09.02.23.
//

import UIKit
import ArcwindResume
import ArcwindUI

final class MainWindowController: UIResponder, UIWindowSceneDelegate {
    
    static let configurationName = "MainWindowController"
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        self.configureWindow(
            for: windowScene,
            userActivity: session.stateRestorationActivity ?? scene.userActivity
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

private extension MainWindowController {
    func configureWindow(for windowScene: UIWindowScene, userActivity: NSUserActivity?) {
        let window = UIWindow(windowScene: windowScene)
        
        let controller = ResumeDocumentViewController()
        window.rootViewController = controller
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
