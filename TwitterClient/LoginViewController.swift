//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/14/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "VN9Ljj7uBedjyr8fZr9MounN7", consumerSecret: "ZD4DdCXoOdKKsyYasD2zMBo4PRRGXu4Kiwxquqfz83Pr2RTS9B")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil,
            success: {(requestToken: BDBOAuth1Credential?) in
            print("I got a token!")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
                UIApplication.shared.open(url, options: [:], completionHandler: { (bool: Bool) in
                    print("Completion Handler Fired!")
                })
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
        })
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
