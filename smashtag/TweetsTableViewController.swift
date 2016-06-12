//
//  TweetsTableViewController.swift
//  smashtag
//
//  Created by Calvert, Martin on 6/11/16.
//  Copyright © 2016 Calvert, Martin. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController, UITextFieldDelegate {
    var tweets = [[Tweet]]()
    var searchtext: String? = "Stanford" {
        didSet {
            tweets.removeAll()
            tableView.reloadData()
            lastSuccessfulRequest = nil
            refresh()
        }
    }
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchtext != nil {
                return TwitterRequest(search: searchtext!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchtext != nil {
            let request = TwitterRequest(search: searchtext!, count: 100)
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    // MARK: - ViewControllerLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchtext
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchtext = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }
}
