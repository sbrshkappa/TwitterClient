//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/21/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var screenName: String!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    var user: User!
    
    
    var tweets: [Tweet]!
    
    let refreshControl = UIRefreshControl()

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initializing Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Get Latest Tweets")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        profileTableView.addSubview(refreshControl)
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.estimatedRowHeight = 200
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        if user == nil {
            if User.currentUser != nil {
                user = User.currentUser
            }
        }
        reloadData(user: user)
    
        
        profileImage.layer.cornerRadius = 5
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
        screenName = user.screenName

        
        //Get user's tweet Timeline
        TwitterClient.sharedInstance?.userTimeLine(screenName: screenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.profileTableView.reloadData()
        }, failure: { (error: Error) in
            print("Error fetching tweets for user: \(error.localizedDescription)")
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        TwitterClient.sharedInstance?.userTimeLine(screenName: screenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.profileTableView.reloadData()
        }, failure: { (error: Error) in
            print("Error Refreshing. Error: \(error.localizedDescription)")
        })
        self.refreshControl.endRefreshing()
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
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UITableViewCell {
            let cell = sender! as! TweetCell
            let indexPath = profileTableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC.tweet = tweet
        }
        if(segue.identifier == "profileReplyComposeSegue"){
            var indexPath: IndexPath!
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? TweetCell {
                        indexPath = profileTableView.indexPath(for: cell)
                    }
                }
            }
            let tweet = tweets[indexPath.row]
            let replyViewController = segue.destination as! ComposeViewController
            replyViewController.replyToID = tweet.tweetID
            replyViewController.replyToScreenName = tweet.authorHandle
        }
    }
    
    
    func reloadData(user: User){
        nameLabel.text = user.name!
        handleLabel.text = "@\(user.screenName!)"
        tweetsCountLabel.text = user.tweetsCount!
        followingCountLabel.text = user.followingCount!
        followersCountLabel.text = user.followersCount!
        
        profileImage.setImageWith(user.profileURL!)
        if(user.profileBackgroundImageURL != nil){
            backgroundImage.setImageWith(user.profileBackgroundImageURL!)
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
