//
//  VPAppManager.swift
//  Pods
//
//  Created by Christopher Shireman on 2/14/17.
//
//

import UIKit

open class VPAppManager: NSObject {
    public static let shared = VPAppManager()

    var applications: [VPApplication] = [VPApplication]()
    var currentApp: VPApplication?

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

        currentApp.showNagScreen()
    }
}
