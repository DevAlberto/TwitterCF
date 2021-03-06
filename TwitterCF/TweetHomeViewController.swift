//
//  ViewController.swift
//  TwitterCF
//
//  Created by Alberto Vega Gonzalez on 10/26/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class TweetHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    
    func identifier() -> String {
        return "TweetHomeViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getAccount()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAccount() {
        LoginService.loginTwitter ({ (error, account) -> () in
            
            if let error = error {
                print(error)
                return
            }
            
            if let account = account {
                TwitterService.sharedService.account = account
                self.authenticateUser()
            }
        })
    }
    
    func authenticateUser() {
        TwitterService.getAuthUser { (error, user) -> () in
            
            if let error = error {
                print(error)
                return
            }
            
            if let user = user {
                TwitterService.sharedService.user = user
                self.getTweets()
            }
        }
    }
    
    func getTweets() {
        TwitterService.tweetsFromHomeTimeLine { (error, tweets) -> () in
            
            if let error = error {
                print(error)
                return
            }
            
            if let tweets = tweets {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tweets = tweets
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func setupTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 101
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let spinner = UIRefreshControl(frame: CGRectMake(0.0, 0.0, 44.0, 44.0))
        spinner.addTarget(self, action: "getTweets", forControlEvents: UIControlEvents.AllEvents)
        self.tableView.addSubview(spinner)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getTweets")
        navigationItem.rightBarButtonItem = refreshButton
        title = "Tweets"
        
        let customTweetCellXib = UINib(nibName: "CustomTweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(customTweetCellXib, forCellReuseIdentifier: CustomTweetTableViewCell.identifier())
    }
    
    // MARK: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetTableViewCell", forIndexPath: indexPath) as? CustomTweetTableViewCell
        cell?.tweet = self.tweets[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == DetailViewController.identifier() {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let selectedTweet = self.tweets[selectedRow]
                let vc = segue.destinationViewController as! DetailViewController
                vc.tweet = selectedTweet
            }
        }
    }
}


