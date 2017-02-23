//
//  VPApplication.swift
//  Pods
//
//  Created by Christopher Shireman on 2/14/17.
//
//

import Foundation
import SwiftyJSON

open class VPApplication: NSObject {

    open var title: String = ""
    open var desc: String = ""
    open var appleId: String = ""
    open var bundleId: String = ""
    open var affiliteLink: String = ""

    open var appIcon: String = ""
    open var nagScreen: VPNagScreen!

    public init(json: JSON) {
        super.init()

        title = json["title"].stringValue
        desc = json["description"].stringValue
        appleId = json["apple_id"].stringValue
        bundleId = json["bundle_id"].stringValue
        affiliteLink = json["affiliate_link"].stringValue

        appIcon = json["app_icon"].stringValue
        nagScreen = VPNagScreen(json: json["nag_screen"])
    }

    public func showNagScreen() {
        guard let nagScreen = self.nagScreen else {
            return
        }

        if nagScreen.canShow() {
            nagScreen.show()
        }

        nagScreen.incrementCount()
    }

    public func url() -> URL {
        if affiliteLink != "" {
            return URL(string: affiliteLink)!
        }

        return URL(string: "https://itunes.apple.com/us/app/apple-store/id\(appleId)?mt=8")!
    }
}
