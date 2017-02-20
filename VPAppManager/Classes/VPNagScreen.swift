//
//  VPNagScreen.swift
//  Pods
//
//  Created by Christopher Shireman on 2/14/17.
//
//

import UIKit
import SwiftyJSON

public enum NagType: String {
    case purchase = "purchase"
    case application = "application"
}

public protocol VPNagScreenDelegate {
    func nagScreenAcceptPressed(_ nagScreen: VPNagScreen)
    func nagScreenDeclinePressed(_ nagScreen: VPNagScreen)
}

open class VPNagScreen: NSObject {
    open var title: String = ""
    open var message: String = ""
    open var acceptButtonTitle: String = ""
    open var declineButtonTitle: String = ""

    open var frequency: Int = 0
    open var type: NagType = .purchase
    open var isActive: Bool = true
    open var value: String = ""

    open var delegate: VPNagScreenDelegate?

    public init(json: JSON) {
        super.init()

        title = json["title"].stringValue
        message = json["message"].stringValue
        acceptButtonTitle = json["accept_button_title"].stringValue
        declineButtonTitle = json["decline_button_title"].stringValue

        frequency = json["frequency"].intValue
        type = NagType(rawValue: json["type"].stringValue) ?? .purchase
        isActive = json["is_active"].boolValue
        value = json["value"].stringValue
    }

    public func canShow() -> Bool {
        let defaults = UserDefaults.standard
        var count = defaults.integer(forKey: "VPNagScreenCount")

        return count >= frequency
    }

    public func show() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: acceptButtonTitle, style: .default, handler: { (action) in
            self.delegate?.nagScreenAcceptPressed(self)
        }))

        alert.addAction(UIAlertAction(title: declineButtonTitle, style: .cancel, handler: { (action) in
            self.delegate?.nagScreenDeclinePressed(self)
        }))

        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated: true, completion: nil)
        }
    }

    public func incrementCount() {
        let defaults = UserDefaults.standard
        var count = defaults.integer(forKey: "VPNagScreenCount")
        count += 1

        if count > frequency {
            count = 0
        }

        defaults.set(count, forKey: "VPNagScreenCount")
        defaults.synchronize()
    }
}

