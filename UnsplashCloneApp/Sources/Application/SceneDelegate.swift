//
//  SceneDelegate.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
//        // Data Layer
        let photoRepository = PhotoRepositoryImpl(clientID: "UKHUCSynoHy_OOV_e-5Joa81I5JGwWaO1OAV8iFTonU")
        let photoBookmarkRepository = PhotoBookmarkRepositoryImpl()
//
//        // Domain Layer
        let loadPhotosUseCase = LoadPhotosUseCaseImpl(repository: photoRepository)
        let toggleBookmarkUseCase = ToggleBookmarkUseCaseImpl(repository: photoBookmarkRepository)
        // View Layer
        
        let photoListViewController = BaseNavigationController(
            rootViewController: PhotoListViewController(
                reactor: PhotoListViewReactor(
                    loadPhotosUseCase: loadPhotosUseCase,
                    toggleBookmarkUseCase: toggleBookmarkUseCase
                )
            )
        )
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = photoListViewController
        self.window?.makeKeyAndVisible()
    }
}
