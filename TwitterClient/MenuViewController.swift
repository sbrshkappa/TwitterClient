//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Sabareesh Kappagantu on 4/21/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController") as! UINavigationController
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        hamburgerViewController.contentViewController = tweetsViewController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Home", "Profile", "Mentions"]
        cell.menuLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
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
