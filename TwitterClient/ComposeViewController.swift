//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/16/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        //Get Current Account
        if User.currentUser != nil {
            user = User.currentUser
        }
        
        //Set All the Elements in the View
        
        nameLabel.text = user!.name
        handleLabel.text = user!.screenName
        profileImage.setImageWith(user!.profileURL!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TextView Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfCharacters = newText.characters.count
        if(textView.text.characters.count > 140){
            print("Cannot add more characters!")
        }
        return numberOfCharacters <= 140
        
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: Any) {
        
        let tweetText = textView.text
        //Posting the Tweet
        if ((tweetText?.characters.count)! > 0){
            TwitterClient.sharedInstance?.sendTweet(message: tweetText!, success: { (tweet: Tweet) in
                
                self.dismiss(animated: true, completion: nil)
                
            }, failure: { (error: Error) in
                print("Error while posting Tweet: \(error.localizedDescription)")
            })
        } else {
            print("Cannot Post Tweet! There is no text!")
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
