//
//  Tweet.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var author: String?
    var authorHandle: String?
    var profileImageUrl: URL?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favortiesCount: Int = 0
    
    init(dictionary: NSDictionary){
        
//        print(dictionary)
        
        let authorDictionary = dictionary["user"] as? NSDictionary
        if let authorDictionary = authorDictionary {
            author = authorDictionary["name"] as? String
            let profileImageUrlString = authorDictionary["profile_image_url_https"] as? String
            profileImageUrl = URL(string: profileImageUrlString!)
            authorHandle = authorDictionary["screen_name"] as? String
        }
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favortiesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        return tweets
    }

}
