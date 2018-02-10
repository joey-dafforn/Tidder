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
                    if let res = response as? HTTPURLResponse {
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
