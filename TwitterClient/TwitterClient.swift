//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/15/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "VN9Ljj7uBedjyr8fZr9MounN7", consumerSecret: "ZD4DdCXoOdKKsyYasD2zMBo4PRRGXu4Kiwxquqfz83Pr2RTS9B")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"),
                                                        scope:nil,
                                                        success: {(requestToken: BDBOAuth1Credential?) in
                                                            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
                                                            UIApplication.shared.open(url, options: [:], completionHandler: { (bool: Bool) in
                                                                print("Completion Handler Fired!")
                                                            })
                                                        },
                                                        failure: { (error: Error?) in
                                                                print("error: \(error?.localizedDescription)")
                                                                self.loginFailure?(error!)
                                                        })
    }
    
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            print("I got the Access Token!")
            self.loginSuccess?()
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        //Getting Tweet Data
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func currentAccount() {
        //Getting User Data
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            //               print("user: \(user)")
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("tagline: \(user.tagline)")
            print("screen name: \(user.screenName)")
            print("profile image url: \(user.profileURL)")
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
}
