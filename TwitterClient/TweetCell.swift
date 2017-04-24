//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func TweetCellDelegate(screenName: String)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate?
    var rowNumber: Int?
    

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetInactiveImage: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.author
            twitterHandleLabel.text = "@\(tweet.authorHandle!)"
            profileImage.setImageWith(tweet.profileImageUrl!)
            if(tweet.retweetedBy != nil){
                retweetLabel.isHidden = false
                retweetLabel.text = "\(tweet.retweetedBy!) Retweeted"
                retweetInactiveImage.isHidden = false
            } else {
                retweetLabel.isHidden = true
                retweetInactiveImage.isHidden = true
            }
            timestampLabel.text = tweet.timeAgo
            
            if (tweet.retweeted)! {
                retweetButton.isSelected = true
            } else {
                retweetButton.isSelected = false
            }
            
            if (tweet.favorited)! {
                favoriteButton.isSelected = true
            } else {
                favoriteButton.isSelected = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        retweetButton.setImage(UIImage(named: "retweetAction"), for: .normal)
        retweetButton.setImage(UIImage(named: "retweetActionOn"), for: .selected)
        
        favoriteButton.setImage(UIImage(named: "likeAction"), for: .normal)
        favoriteButton.setImage(UIImage(named: "likeActionOn"), for: .selected)
        
        
        //Add a TapGesture to the image
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func handleTap(_ sender: Any){
        if delegate != nil {
            delegate!.TweetCellDelegate!(screenName: tweet.authorHandle!)
        }
        
    }

    @IBAction func onRetweet(_ sender: Any) {
        let button = sender as? UIButton
        
        if !(button?.isSelected)! {
            
            button?.isSelected = true
            //Gotta change the image and send a Retweet POST
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetID!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while Retweeting: \(error.localizedDescription)")
            })
        } else {
            button?.isSelected = false
            TwitterClient.sharedInstance?.unRetweet(id: tweet.tweetID!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while UnRetweeting: \(error.localizedDescription)")
            })

        }
    }
    
    
    
    @IBAction func onFavorite(_ sender: Any) {
        
        let button = sender as? UIButton
        
        if !(button?.isSelected)! {
            
            button?.isSelected = true
            TwitterClient.sharedInstance?.favorite(id: tweet.tweetID!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while trying to Favorite: \(error.localizedDescription)")
            })
            
        } else {
            
            button?.isSelected = false
            TwitterClient.sharedInstance?.unFavorite(id: tweet.tweetID!, success: { (tweet: Tweet) in
                
            }, failure: { (error: Error) in
                print("Error while trying to UnFavorite: \(error.localizedDescription)")
            })
            
        }
        
    }
    
    
    
    
    
    
    
}
