//
//  ComposeTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joey Dafforn on 2/15/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var composeText: UITextView!
    var delegate: ComposeViewControllerDelegate?
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            usernameLabel.text = user.name
            handleLabel.text = "@\(user.screenName!)"
            profilePictureImage.af_setImage(withURL: URL(string: user.profileImageURL)!)
            profilePictureImage.layer.cornerRadius = 16
            profilePictureImage.clipsToBounds = true
        }
        composeText.delegate = self
        composeText.text = "What's happening?"
        composeText.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: composeText.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if composeText.textColor == UIColor.lightGray {
            composeText.text = nil
            composeText.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = composeText.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        characterCountLabel.text = "\(140 - updatedText.count)"
        return updatedText.count < 140 // Change limit based on your requirement.
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
