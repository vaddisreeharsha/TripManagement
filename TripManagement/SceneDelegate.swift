//
//  SceneDelegate.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 23/09/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        UIApplication.shared.delegate?.applicationDidEnterBackground?(.shared)
        if !UIApplication.shared.connectedScenes.contains(where: { $0.activationState == .background || $0 != scene}){
            UIApplication.shared.delegate?.applicationWillResignActive?(.shared)
        }

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Did enter back ground Screen Dlegate")
        if !UIApplication.shared.connectedScenes.contains(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive}){
            UIApplication.shared.delegate?.applicationDidEnterBackground?(.shared)
        }
        PersistentStorage.shared.saveContext()
    }


}

