//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing a Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Get Latest Tweets")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsTableView.addSubview(refreshControl)
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        let twitterColor = UIColor(red: 29/256, green: 202/256, blue: 255/256, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twitterColor
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //Getting HomeTimeline data
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
        }, failure: { (error: Error) in
            print("Error fetching Tweets. Error: \(error.localizedDescription)")
        })
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print("Error Refreshing. Error: \(error.localizedDescription)")
        })
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    //TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
