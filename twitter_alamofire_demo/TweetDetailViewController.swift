//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joey Dafforn on 2/15/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetDetailViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            usernameLabel.text = tweet.user.name
            handleLabel.text = "@\(tweet.user.screenName!)"
            timeLabel.text = tweet.createdAtString
            tweetTextField.text = tweet.text
            tweetTextField.resolveHashTags()
            retweetLabel.text = "\(String(tweet.retweetCount))"
            favoriteLabel.text = "\(String(describing: tweet.favoriteCount!))"
            replyImage.image = #imageLiteral(resourceName: "reply-icon")
            favoriteImage.isUserInteractionEnabled = true
            retweetImage.isUserInteractionEnabled = true
            if (tweet.favorited == true) {
                favoriteImage.image = #imageLiteral(resourceName: "favor-icon-red")
            }
            else {
                favoriteImage.image = #imageLiteral(resourceName: "favor-icon")
            }
            if (tweet.retweeted == true) {
                retweetImage.image = #imageLiteral(resourceName: "retweet-icon-green")
            }
            else {
                retweetImage.image = #imageLiteral(resourceName: "retweet-icon")
            }
            retweetImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retweetPost)))
            favoriteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoritePost)))
            profilePictureImage.af_setImage(withURL: URL(string: tweet.tweetImage)!)
            profilePictureImage.layer.cornerRadius = 16
            profilePictureImage.clipsToBounds = true
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func favoritePost() {
        favoriteImage.isUserInteractionEnabled = false
        if let favorited = tweet.favorited {
            if favorited {
                APIManager.shared.unFavorite(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteImage.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteImage.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                tweet.favorited = false
                let count1 = tweet.favoriteCount
                tweet.favoriteCount = count1! - 1
                favoriteImage.image = #imageLiteral(resourceName: "favor-icon")
            } else {
                APIManager.shared.favoriteATweet(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteImage.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteImage.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                tweet.favorited = true
                let count1 = tweet.favoriteCount
                tweet.favoriteCount = count1! + 1
                favoriteImage.image = #imageLiteral(resourceName: "favor-icon-red")
            }
        } else {
            APIManager.shared.favoriteATweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.favoriteImage.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.favoriteImage.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
            tweet.favorited = true
            let count1 = tweet.favoriteCount
            tweet.favoriteCount = count1! + 1
            favoriteImage.image = #imageLiteral(resourceName: "favor-icon-red")
        }
    }
    
    @objc func retweetPost() {
        if tweet.retweeted {
            retweetImage.isUserInteractionEnabled = false
            APIManager.shared.unRetweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetImage.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetImage.isUserInteractionEnabled = true
                    //self.delegate?.did(post: tweet!)
                }
            })
            tweet.retweeted = false
            let count = tweet.retweetCount
            tweet.retweetCount = count - 1
            retweetImage.image = #imageLiteral(resourceName: "retweet-icon")
        } else {
            retweetImage.isUserInteractionEnabled = false
            APIManager.shared.retweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetImage.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetImage.isUserInteractionEnabled = true
                    //self.delegate?.did(post: tweet!)
                }
            })
            tweet.retweeted = true
            let count = tweet.retweetCount
            tweet.retweetCount = count + 1
            retweetImage.image = #imageLiteral(resourceName: "retweet-icon-green")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
