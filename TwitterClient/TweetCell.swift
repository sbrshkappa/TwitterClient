//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetInactiveImage: UIImageView!
    
    
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
