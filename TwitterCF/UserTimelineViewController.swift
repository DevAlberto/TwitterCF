//
//  UserTimelineViewController.swift
//  TwitterCF
//
//  Created by Alberto Vega Gonzalez on 10/30/15.
//  Copyright © 2015 Alberto Vega Gonzalez. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    var selectedTweet: Tweet!

    func identifier() -> String {
        return "UserTimeLineViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        self.getTweets()
        
//        if let user = selectedTweet.user {
//            TwitterService.tweetsFromUserTimeLineForUsername(user.name) { (error, tweets) -> () in
//                //do something with tweets
//            }
//        }
        


        // Do any additional setup after loading the view.
    }
    
    func getTweets() {
        if let user = selectedTweet.user {
            TwitterService.tweetsFromUserTimeLineForUsername(user.name) { (error, tweets) -> () in
                //do something with tweets
              
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
    }
    
    func setupTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 101
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let spinner = UIRefreshControl(frame: CGRectMake(0.0, 0.0, 44.0, 44.0))
        
        spinner.addTarget(self, action: "updateFeed:", forControlEvents: UIControlEvents.AllEvents)
        self.tableView.addSubview(spinner)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getTweets")
        navigationItem.rightBarButtonItem = refreshButton
        
        let customTweetCellXib = UINib(nibName: "CustomTweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(customTweetCellXib, forCellReuseIdentifier: CustomTweetTableViewCell.identifier())
        
        let customUserTimelineHeaderXib = UINib(nibName: "CustomUserTimelineHeader", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(customUserTimelineHeaderXib, forHeaderFooterViewReuseIdentifier: "CustomUserTimelineHeader")
        
        }
    
    override func viewWillAppear(animated: Bool) {
    
        super.viewWillAppear(animated)
        
        let customUserTimelineHeader = CustomUserTimelineHeader()
        
        customUserTimelineHeader.userName?.text = "Testing"
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: UITableViewHeader
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return CustomUserTimelineHeader.view()
    }
    
    // MARK: UITableView

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetTableViewCell", forIndexPath: indexPath) as! CustomTweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        
//        customUserTimelineHeader.tweet = tweets[indexPath.row]
        
        
//        if let tweetCell = cell {
//            if let user = tweet.user {
//                
//                tweetCell.userName?.text = "Tweeted by: \(user.name)"
//                //                        tweetCell.profileImage?.image = UIImage(data: tweet.user?.profileImageURL)
//            }
//            tweetCell.tweetTextLabel?.text = tweet.text
//        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
