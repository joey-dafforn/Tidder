//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

class TweetCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var tweetPictureImage: UIImageView!
    @IBOutlet weak var favoriteImageThing: UIImageView!
    @IBOutlet weak var retweetImageThing: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UITextView!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            tweetTextLabel.resolveHashTags()
            usernameLabel.text = tweet.user.name
            twitterHandleLabel.text = "@\(tweet.user.screenName)"
            dateLabel.text = tweet.createdAtString
            retweetCountLabel.text = "\(String(tweet.retweetCount))"
            favoriteCountLabel.text = "\(String(describing: tweet.favoriteCount!))"
            favoriteImageThing.isUserInteractionEnabled = true
            retweetImageThing.isUserInteractionEnabled = true
            if (tweet.favorited == true) {
                favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon-red")
            }
            else {
                favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon")
            }
            if (tweet.retweeted == true) {
                retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon-green")
            }
            else {
                retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon")
            }
            retweetImageThing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retweetPost)))
            favoriteImageThing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoritePost)))
            tweetPictureImage.af_setImage(withURL: URL(string: tweet.tweetImage)!)
            tweetPictureImage.layer.cornerRadius = 16
            tweetPictureImage.clipsToBounds = true
            
        }
    }
    
    @objc func retweetPost() {
        if tweet.retweeted {
            retweetImageThing.isUserInteractionEnabled = false
            APIManager.shared.unRetweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetImageThing.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetImageThing.isUserInteractionEnabled = true
                    //self.delegate?.did(post: tweet!)
                }
            })
            tweet.retweeted = false
            let count = tweet.retweetCount
            tweet.retweetCount = count - 1
            retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon")
        } else {
            retweetImageThing.isUserInteractionEnabled = false
            APIManager.shared.retweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetImageThing.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetImageThing.isUserInteractionEnabled = true
                    //self.delegate?.did(post: tweet!)
                }
            })
            tweet.retweeted = true
            let count = tweet.retweetCount
            tweet.retweetCount = count + 1
            retweetImageThing.image = #imageLiteral(resourceName: "retweet-icon-green")
        }
    }
    
    @objc func favoritePost() {
        favoriteImageThing.isUserInteractionEnabled = false
        if let favorited = tweet.favorited {
            if favorited {
                APIManager.shared.unFavorite(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteImageThing.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteImageThing.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                tweet.favorited = false
                let count1 = tweet.favoriteCount
                tweet.favoriteCount = count1! - 1
                favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon")
            } else {
                APIManager.shared.favoriteATweet(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteImageThing.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteImageThing.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                tweet.favorited = true
                let count1 = tweet.favoriteCount
                tweet.favoriteCount = count1! + 1
                favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon-red")
            }
        } else {
            APIManager.shared.favoriteATweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.favoriteImageThing.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.favoriteImageThing.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
            tweet.favorited = true
            let count1 = tweet.favoriteCount
            tweet.favoriteCount = count1! + 1
            favoriteImageThing.image = #imageLiteral(resourceName: "favor-icon-red")
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
