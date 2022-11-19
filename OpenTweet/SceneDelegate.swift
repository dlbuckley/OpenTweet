//
//  SceneDelegate.swift
//  OpenTweet
//
//  Created by Dale Buckley on 14/11/2022.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        window = UIWindow(windowScene: windowScene)
        let timelineViewController = TimelineViewController(viewModel: TimelineViewModel(context: LocalTweetsContext()))
        timelineViewController.title = NSLocalizedString("timeline.title", comment: "The title displayed in the navigation bar at the top of the timeline")
        let navigationController = UINavigationController(rootViewController: timelineViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
