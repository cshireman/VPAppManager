//
//  VPAppManagerService.swift
//  Pods
//
//  Created by Christopher Shireman on 2/14/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON

open class VPAppManagerService: NSObject {
    open static let shared = VPAppManagerService()

    open func getApplications(completion: @escaping (_ apps: [VPApplication])-> Void) {
        guard let url = URL(string: "http://shireman.net/app_manager.json") else {
            completion([])
            return
        }

        Alamofire.request(url).responseJSON { (response) in
            if let jsonInfo = response.result.value {
                let json = JSON(jsonInfo)
                var applications = [VPApplication]()
                for jsonApp in json.arrayValue {
                    applications.append(VPApplication(json: jsonApp))
                }

                completion(applications)
                return
            }

            completion([])
        }
    }
}
