//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
//    func favoriteAction(tapGesture: UITapGestureRecognizer) {
//        let tapLocation = tapGesture.location(in: self.tableView)
//        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
//        let cell = self.tableView.cellForRow(at: indexPath!) as! TweetCell
//        if cell.tweet.favorited == true {
//            cell.tweet.favorited = false
//            cell.favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon")
//        }
//        else {
//            cell.tweet.favorited = true
//            cell.favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon-red")
//            APIManager.shared.favoriteATweet(tweetId: String(cell.tweet.id), completion: { (asdf, error) in
//                if error != nil {
//                    print(error?.localizedDescription)
//                }
//                else {
//                    print(asdf)
//                }
//            })
//        }
//    }
    /////////////////
//    func retweetAction(tapGesture: UITapGestureRecognizer) {
//        let tapLocation = tapGesture.location(in: self.tableView)
//        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
//        let cell = self.tableView.cellForRow(at: indexPath!) as! TweetCell
//        if cell.tweet.retweeted == true {
//            cell.tweet.retweeted = false
//            cell.retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon")
//        }
//        else {
//            cell.tweet.retweeted = true
//            cell.retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon-green")
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
//        let tapGestureFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteAction(tapGesture:)))
//        let tapGestureRetweet = UITapGestureRecognizer(target: self, action: #selector(retweetAction(tapGesture:)))
        cell.tweet = tweets[indexPath.row]
//        cell.favoriteImageThing.isUserInteractionEnabled = true
//        cell.favoriteImageThing.addGestureRecognizer(tapGestureRetweet)
//        cell.favoriteImageThing.addGestureRecognizer(tapGestureFavorite) // Increment favorited when image is clicked
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
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
