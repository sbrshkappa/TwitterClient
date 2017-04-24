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
    var retweetedBy: String?
    var authorHandle: String?
    var profileImageUrl: URL?
    var text: String?
    var timestamp: Date?
    var timestampAsString: String?
    var timeAgo: String?
    var retweetCount: Int = 0
    var favortiesCount: Int = 0
    var tweetID: String?
    var retweeted: Bool?
    var favorited: Bool?
    
    func isRetweet(dictionary: NSDictionary) -> Bool{
        let entities = dictionary["entities"] as? NSDictionary
        let keyExists = entities?["retweeted_status"] != nil
        if keyExists {
            return true
        }
        return false
    }
    
    func getRetweet(dictionary: NSDictionary) -> NSDictionary{
        let entities = dictionary["entities"] as? NSDictionary
        let retweetDictionary = entities?["retweeted_status"] as? NSDictionary
        return retweetDictionary!
    }
    
    init(dictionary: NSDictionary){
        
        //print(dictionary)
        
        let isARetweet = dictionary["retweeted_status"] != nil
        if isARetweet {
            let realDictionary = dictionary["retweeted_status"] as? NSDictionary
            if let realDictionary = realDictionary {
                
                let realAuthorDictionary = realDictionary["user"] as? NSDictionary
                if let realAuthorDictionary = realAuthorDictionary {
                    
                    author = realAuthorDictionary["name"] as? String
                    let profileImageUrlStringLowRes = realAuthorDictionary["profile_image_url_https"] as? String
                    let profileImageUrlString = profileImageUrlStringLowRes?.replacingOccurrences(of: "_normal", with: "")
                    profileImageUrl = URL(string: profileImageUrlString!)
                    authorHandle = realAuthorDictionary["screen_name"] as? String
                    
                } //if realAuthor
                text = realDictionary["text"] as? String
                tweetID = realDictionary["id_str"] as? String
                
                let timeStampString = realDictionary["created_at"] as? String
                if let timeStampString = timeStampString{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                    timestamp = formatter.date(from: timeStampString)
                    formatter.dateFormat = "MM/dd/yy hh:mm a"
                    timestampAsString = formatter.string(from: timestamp!)
                    
                    let timeInterval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp!, to: Date())
                    if let year = timeInterval.year, year > 0 {
                        
                        formatter.dateFormat = "MMM yyyy"
                        timeAgo = formatter.string(from: timestamp!)
                        
                    } else if let day = timeInterval.day, day > 0 {
                        
                        formatter.dateFormat = "MMM d"
                        timeAgo = formatter.string(from: timestamp!)
                        
                    }else if let hour = timeInterval.hour, hour > 0 {
                        
                        timeAgo = "\(hour) hr"
                        
                    } else if let min = timeInterval.minute, min > 0 {
                        
                        timeAgo = "\(min) min"
                    } else {
                        timeAgo = "Just now"
                    }
                    
                    retweeted = realDictionary["retweeted"] as? Bool
                    retweetCount = (realDictionary["retweet_count"] as? Int) ?? 0
                    favorited = realDictionary["favorited"] as? Bool
                    favortiesCount = (realDictionary["favourites_count"] as? Int) ?? 0
                }
                //Who retweeted it?
                let retweeter = dictionary["user"] as? NSDictionary
                if let retweeter = retweeter {
                    retweetedBy = retweeter["name"] as? String
                }
                
            } // if realDictionary
        } else {
        
            let authorDictionary = dictionary["user"] as? NSDictionary
            if let authorDictionary = authorDictionary {
                    author = authorDictionary["name"] as? String
                    let profileImageUrlStringLowRes = authorDictionary["profile_image_url_https"] as? String
                    let profileImageUrlString = profileImageUrlStringLowRes?.replacingOccurrences(of: "_normal", with: "")
                    profileImageUrl = URL(string: profileImageUrlString!)
                    authorHandle = authorDictionary["screen_name"] as? String
            }
            
            text = dictionary["text"] as? String
            tweetID = dictionary["id_str"] as? String
            
            let timeStampString = dictionary["created_at"] as? String
            if let timeStampString = timeStampString{
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                timestamp = formatter.date(from: timeStampString)
                
            
            let timeInterval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp!, to: Date())
            if let year = timeInterval.year, year > 0 {
                
                    formatter.dateFormat = "MMM yyyy"
                    timeAgo = formatter.string(from: timestamp!)
                
            } else if let day = timeInterval.day, day > 0 {
                
                    formatter.dateFormat = "MMM d"
                    timeAgo = formatter.string(from: timestamp!)
                
            }else if let hour = timeInterval.hour, hour > 0 {
                
                    timeAgo = "\(hour) hr"
                
            } else if let min = timeInterval.minute, min > 0 {
                
                    timeAgo = "\(min) min"
            } else {
                    timeAgo = "Just now"
            }
            
            retweeted = dictionary["retweeted"] as? Bool
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favorited = dictionary["favorited"] as? Bool
            favortiesCount = (dictionary["favourites_count"] as? Int) ?? 0
        }
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
