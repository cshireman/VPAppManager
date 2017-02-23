//
//  VPMoreAppsCell.swift
//  Pods
//
//  Created by Christopher Shireman on 2/22/17.
//
//

import UIKit
import SDWebImage

class VPMoreAppsCell: UITableViewCell {

    static let reuseId = "VPMoreAppsCell"
    static let cellHeight: CGFloat = 75.0

    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var appImageView: UIImageView!

    var app: VPApplication!

    func update() {
        guard app != nil else {
            return
        }

        titleLabel.text = app.title
        descriptionLabel.text = app.desc

        if let url = URL(string: "http://shireman.net/images/\(app.appIcon)") {
            appImageView.sd_setImage(with: url, completed: { (image, error, cacheType, imageUrl) in
                DispatchQueue.main.async {
                    self.appImageView.image = image
                    self.appImageView.contentMode = .scaleAspectFill
                    self.appImageView.clipsToBounds = true
                    self.appImageView.layer.cornerRadius = 10.0
                }
            })
        }
    }
}
