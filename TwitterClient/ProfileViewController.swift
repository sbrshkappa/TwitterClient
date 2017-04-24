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

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profileTweetDetailSegue" ){
            let indexPath = profileTableView.indexPath(for: sender as! TweetCell)!
            let tweet = tweets[indexPath.row]
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
