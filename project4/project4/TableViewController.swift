//
//  TableViewController.swift
//  project4
//
//  Created by Артем Чжен on 16/12/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var websites = ["github.com", "iccup.com", "google.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Simple Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? ViewController {
            vc.websites = websites
            vc.selectedWebsite = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
