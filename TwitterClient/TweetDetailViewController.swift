//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/16/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetInactiveImage: UIImageView!
    
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retweetButton.setImage(UIImage(named: "retweetAction"), for: .normal)
        retweetButton.setImage(UIImage(named: "retweetActionOn"), for: .selected)
        
        favoriteButton.setImage(UIImage(named: "likeAction"), for: .normal)
        favoriteButton.setImage(UIImage(named: "likeActionOn"), for: .selected)
        
        
        nameLabel.text = tweet?.author
        handleLabel.text = tweet?.authorHandle
        profileImage.setImageWith((tweet?.profileImageUrl!)!)
        text.text = tweet?.text
        timestampLabel.text = tweet?.timestampAsString
        if(tweet?.retweetedBy != nil){
            retweetedByLabel.isHidden = false
            retweetedByLabel.text = "\((tweet?.retweetedBy)!)" + " Retweeted"
            retweetInactiveImage.isHidden = false
        } else {
            retweetedByLabel.isHidden = true
            retweetInactiveImage.isHidden = true
        }
        if (tweet?.retweeted)! {
            retweetButton.isSelected = true
        } else {
            retweetButton.isSelected = false
        }
        
        if (tweet?.favorited)! {
            favoriteButton.isSelected = true
        } else {
            favoriteButton.isSelected = false
        }
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        
        let button = sender as? UIButton
        
        if !(button?.isSelected)! {
            
            button?.isSelected = true
            TwitterClient.sharedInstance?.favorite(id: (tweet?.tweetID!)!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while trying to Favorite: \(error.localizedDescription)")
            })
            
        } else {
            
            button?.isSelected = false
            TwitterClient.sharedInstance?.unFavorite(id: (tweet?.tweetID!)!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while trying to UnFavorite: \(error.localizedDescription)")
            })
            
        }
        
    }
    
    
    @IBAction func onRetweetButton(_ sender: Any) {
        
        let button = sender as? UIButton
        
        if !(button?.isSelected)! {
            
            button?.isSelected = true
            //Gotta change the image and send a Retweet POST
            TwitterClient.sharedInstance?.retweet(id: (tweet?.tweetID!)!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while Retweeting: \(error.localizedDescription)")
            })
        } else {
            button?.isSelected = false
            TwitterClient.sharedInstance?.unRetweet(id: (tweet?.tweetID!)!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while UnRetweeting: \(error.localizedDescription)")
            })
            
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
