//
//  FeedsVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/30/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class FeedsVC: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var feeds = [Feeds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            DataService.instance.getFeedsData(returnedPostsCompleted: { (success, error, returnedFeeds) in
                if success {
                    self.feeds = returnedFeeds!
                    self.feedTableView.reloadData()
                }
            })
        }
    }
    
    
}

extension FeedsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? feedCell else {return UITableViewCell()}
        let myFeeds = feeds[indexPath.row]
        cell.updateViews(feeds: myFeeds)
        return cell
    }
    
    
}
