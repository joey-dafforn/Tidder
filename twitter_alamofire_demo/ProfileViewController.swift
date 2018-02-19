//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joey Dafforn on 2/18/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var taglineLabel: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.current {
            usernameLabel.text = user.name
            twitterHandle.text = "@\(user.screenName!)"
            profileImage.af_setImage(withURL: URL(string: user.profileImageURL)!)
            profileImage.layer.cornerRadius = 16
            profileImage.clipsToBounds = true
            taglineLabel.text = user.description!
            numFollowersLabel.text = "\(user.followerCount!)"
            numFollowingLabel.text = "\(user.followingCount!)"
            numTweetsLabel.text = "\(user.numTweets!)"

        }
        
        // Do any additional setup after loading the view.
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
