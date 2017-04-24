//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/23/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    @IBOutlet weak var mentionsTableView: UITableView!
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    var userProfile: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Get Latest Tweets")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        mentionsTableView.addSubview(refreshControl)
        
        
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        mentionsTableView.estimatedRowHeight = 200
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        
        let twitterColor = UIColor(red: 29/256, green: 202/256, blue: 255/256, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twitterColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        //Getting Mentions Timeline Data
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
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
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print("Error Refreshing. Error: \(error.localizedDescription)")
        })
    }
    
    
    //Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mentionsTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    //Tweet Cell Delegate
    func TweetCellDelegate(screenName: String) {
        
        //Get User for a ScreenName
        TwitterClient.sharedInstance?.getUserWithScreenName(screenName: screenName, success: { (user: User) in
            self.userProfile = user
            self.performSegue(withIdentifier: "mentionsToProfileSegue", sender: nil)
        }, failure: { (error: Error) in
            print("Unable to fetch User Data: \(error.localizedDescription)")
        })
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "mentionsDetailSegue" ){
            let indexPath = mentionsTableView.indexPath(for: sender as! TweetCell)!
            let tweet = tweets[indexPath.row]
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC.tweet = tweet
        }
        if( segue.identifier == "mentionsReplySegue"){
            var indexPath: IndexPath!
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? TweetCell {
                        indexPath = mentionsTableView.indexPath(for: cell)
                    }
                }
            }
            let tweet = tweets[indexPath.row]
            let replyViewController = segue.destination as! ComposeViewController
            replyViewController.replyToID = tweet.tweetID
            replyViewController.replyToScreenName = tweet.authorHandle
        }
        if(segue.identifier == "mentionsToProfileSegue") {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = userProfile!
        }
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
