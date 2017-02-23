//
//  VPAppManager.swift
//  Pods
//
//  Created by Christopher Shireman on 2/14/17.
//
//

import UIKit

public protocol VPAppManagerDelegate {
    func shouldDisplayNagScreen(_ nagScreen: VPNagScreen) -> Bool
}

open class VPAppManager: NSObject {
    public static let shared = VPAppManager()

    var applications: [VPApplication] = [VPApplication]()
    var currentApp: VPApplication?

    open var delegate: VPAppManagerDelegate?

    override init() {
        super.init()
        VPAppManagerService.shared.getApplications { (applications) in
            self.applications = applications
            self.setupCurrentApp()
            self.showNagScreenIfNeeded()
        }
    }

    func setupCurrentApp() {
        if let bundleId = Bundle.main.bundleIdentifier {
            for app in self.applications {
                if app.bundleId == bundleId {
                    self.currentApp = app
                }
            }
        }
    }

    func showNagScreenIfNeeded() {
        guard let currentApp = self.currentApp else {
            return
        }

        if delegate?.shouldDisplayNagScreen(currentApp.nagScreen) ?? true {
            currentApp.showNagScreen()
        }
    }

    open func presentMoreAppsController() {
        let storyboard = UIStoryboard(name: "VPAppManager", bundle: Bundle.init(for: VPAppManager.self))
        let navController = storyboard.instantiateViewController(withIdentifier: "MoreAppsNavController")
        let rootController = UIApplication.shared.delegate?.window??.rootViewController

        rootController?.present(navController, animated: true, completion: nil)
    }
}
