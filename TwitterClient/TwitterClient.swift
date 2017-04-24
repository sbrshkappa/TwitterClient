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
    
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    // Get the Home TimeLine
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
    
    
    // Get the Mentions TimeLine 
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            success(tweets)
        }, failure: {(task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    //Get a User's Timeline
    func userTimeLine(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error)-> ()) {
        let params = ["screen_name": screenName]
        
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            let tweetsDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionaries)
            success(tweets)
        }, failure: {(task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    //Get the Current User
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        //Getting User Data
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    
    //Get User for a ScreenName
    
    func getUserWithScreenName(screenName: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/users/show.json?screen_name=\(screenName)"
        get(url, parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            print(userDictionary)
            
            success(user)
        }, failure: {(task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
        
    }
    
    //Post a tweet
    
    func sendTweet(message: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        //Posting a Tweet
        let params = ["status": message]
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetSuccessResponse = response as? NSDictionary
            let tweetSuccess = Tweet(dictionary: tweetSuccessResponse!)
            print(tweetSuccess.text ?? "Simple deafult")
            success(tweetSuccess)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    //Reply to Tweet
    func replyToTweet(message: String, replyTo: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        //Posting a Tweet
        let params = ["status": message,"in_reply_to_status_id": replyTo]
        
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetSuccessResponse = response as? NSDictionary
            let tweetSuccess = Tweet(dictionary: tweetSuccessResponse!)
            print(tweetSuccess.text ?? "Simple deafult")
            success(tweetSuccess)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    
    //Post a Retweet
    
    func retweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let retweetEndPoint = "https://api.twitter.com/1.1/statuses/retweet/\(id).json"
        post(retweetEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let retweetSuccessResponse  = response as? NSDictionary
            let retweetSuccess = Tweet(dictionary: retweetSuccessResponse!)
            success(retweetSuccess)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    //Post an UnRetweet
    
    func unRetweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let unRetweetEndPoint = "https://api.twitter.com/1.1/statuses/retweet/\(id).json"
        post(unRetweetEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let unRetweetSuccessResponse = response as? NSDictionary
            let unRetweetSuccess = Tweet(dictionary: unRetweetSuccessResponse!)
            success(unRetweetSuccess)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    //Favorites a Tweet
    
    func favorite(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params = ["id": id]
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let favoriteSuccessResponse = response as? NSDictionary
            let favoriteResponse = Tweet(dictionary: favoriteSuccessResponse!)
            success(favoriteResponse)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    //Unfavorite a Tweet
    
    func unFavorite(id: String,success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        let params = ["id": id]
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let unFavoriteSuccessResponse = response as? NSDictionary
            let unFavoriteResponse = Tweet(dictionary: unFavoriteSuccessResponse!)
            success(unFavoriteResponse)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    //Get a Tweet by ID
    
    func getTweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()){
        let params = ["id": id]
        post("1.1/statuses/show.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetSuccessResponse = response as? NSDictionary
            let tweetResponse = Tweet(dictionary: tweetSuccessResponse!)
            success(tweetResponse)
        }) { (task: URLSessionDataTask?, error: Error) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
}
