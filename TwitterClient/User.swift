//
//  User.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var profileBackgroundImageURL: URL?
    var tagline: String?
    var followersCount: String?
    var followingCount: String?
    var tweetsCount: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileURL = URL(string: profileUrlString)
        }
        let profileBackgroundImageUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileBackgroundImageURLString = profileBackgroundImageUrlString {
            profileBackgroundImageURL = URL(string: profileBackgroundImageURLString)
        }
        let followersCountInt = dictionary["followers_count"] as? Int
        followersCount = String(describing: followersCountInt!)
        let followingCountInt = dictionary["friends_count"] as? Int
        followingCount = String(describing: followingCountInt!)
        let tweetsCountInt = dictionary["statuses_count"] as? Int
        tweetsCount = String(describing: tweetsCountInt!)
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user){
            
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

}
