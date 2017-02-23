//
//  VPMoreAppsViewController.swift
//  Pods
//
//  Created by Christopher Shireman on 2/22/17.
//
//

import UIKit

class VPMoreAppsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var applications: [VPApplication] = [VPApplication]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupApplications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }

    func setupApplications() {
        applications.removeAll()
        for app in VPAppManager.shared.applications {
            if app != VPAppManager.shared.currentApp {
                applications.append(app)
            }
        }
    }

    func setupAppearance() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        tableView.estimatedRowHeight = VPMoreAppsCell.cellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VPMoreAppsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = applications[indexPath.row]
        let url = app.url()
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Your device is not able to open \(url.absoluteString).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension VPMoreAppsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VPMoreAppsCell = tableView.dequeueReusableCell(withIdentifier: VPMoreAppsCell.reuseId, for: indexPath) as! VPMoreAppsCell

        cell.app = applications[indexPath.row]
        cell.update()

        return cell
    }
}
