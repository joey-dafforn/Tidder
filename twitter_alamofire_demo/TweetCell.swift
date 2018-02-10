//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetPictureImage: UIImageView!
    @IBOutlet weak var favoriteImageThing: UIImageView!
    @IBOutlet weak var retweetImageThing: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
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
            let tweetPictureURL = URL(string: tweet.tweetImage)!
            let session = URLSession(configuration: .default)
            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: tweetPictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading picture: \(e.localizedDescription)")
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if (response as? HTTPURLResponse) != nil {
                        //print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            // Do something with your image.
                            OperationQueue.main.addOperation {
                                self.tweetPictureImage.image = image
                                self.tweetPictureImage.layer.cornerRadius = 16
                                self.tweetPictureImage.clipsToBounds = true
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
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
