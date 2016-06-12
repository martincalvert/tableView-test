//
//  TweetTableViewCell.swift
//  smashtag
//
//  Created by Calvert, Martin on 6/11/16.
//  Copyright © 2016 Calvert, Martin. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView.image = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📸"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageUrl = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageUrl) {
                    tweetProfileImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        
    }
}
