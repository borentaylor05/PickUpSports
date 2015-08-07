//
//  GameVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/9/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import Alamofire
import SwiftyJSON
import FontAwesome_swift

class GameVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var game: Game!
    var comments = [Comment]()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var postCommentView: UIView!
    @IBOutlet weak var newCommentField: UITextField!
    @IBOutlet weak var avatarIV: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var commentsPlayersSC: UISegmentedControl!
    @IBOutlet weak var gameContainer: UIView!
    @IBOutlet weak var joinButton: MKButton!
    @IBOutlet weak var newCommentButton: MKButton!
    
   
    @IBAction func commentsPlayersSCTapped(sender: AnyObject) {
        tableView.reloadData()
        println(commentsPlayersSC.selectedSegmentIndex)
    }
    @IBAction func newCommentButtonTapped(sender: AnyObject) {
        newCommentField.becomeFirstResponder()
        postCommentView.hidden = false
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("hideKeyboard"))
    //    recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
    }
    
    @IBAction func postCommentTapped(sender: AnyObject) {
        var body = self.newCommentField.text
        var comment = Comment(body: body,
                        author: Person(username: GlobalStorage.currentUser.username),
                        game: self.game
                    )
        comment.create(game.id!){ (response) in
            if response["status"].int! == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.comments.append(Comment(body: response["comment"]["body"].string!, author: GlobalStorage.currentUser, postedAt: response["comment"]["created_at"].string!.rails_date()))
                    self.tableView.reloadData()
                })
                self.postCommentView.hidden = true
                self.newCommentField.resignFirstResponder()
            }
        }
    }
    
    @IBAction func joinGameTapped(sender: AnyObject) {
        self.joinButton.titleLabel!.font = UIFont.fontAwesomeOfSize(15)
        game.join(){ (response) in
            println(response)
            if response["result"]["joined"].bool!{
                self.joinButton.backgroundColor = UIColor(rgba: "#66FF66")
                self.joinButton.titleLabel?.textColor = UIColor.whiteColor()
                self.joinButton.setTitle("\(String.fontAwesomeIconWithName(FontAwesome.Check))  Joined", forState: UIControlState.Normal)
            }
            else{
                self.joinButton.backgroundColor = UIColor.MKColor.Red
                self.joinButton.titleLabel?.textColor = UIColor.blackColor()
                self.joinButton.setTitle("\(String.fontAwesomeIconWithName(FontAwesome.Plus))  Join", forState: UIControlState.Normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCommentButton.titleLabel!.font = UIFont.fontAwesomeOfSize(15)
        newCommentButton.setTitle("\(String.fontAwesomeIconWithName(FontAwesome.Comment)) New Comment", forState: UIControlState.Normal)
        self.navigationItem.title = "\(game.sport.name.capitalizedString) Game"
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addGameButtonClicked"), animated: true)
        if (game.joined! == true){
            self.joinButton.backgroundColor = UIColor(rgba: "#66FF66")
            self.joinButton.titleLabel?.textColor = UIColor.whiteColor()
            self.joinButton.titleLabel!.font = UIFont.fontAwesomeOfSize(15)
            joinButton.setTitle("\(String.fontAwesomeIconWithName(FontAwesome.Check))  Joined", forState: UIControlState.Normal)
        }
        else{
            self.joinButton.backgroundColor = UIColor.MKColor.Red
            self.joinButton.titleLabel?.textColor = UIColor.blackColor()
            self.joinButton.titleLabel!.font = UIFont.fontAwesomeOfSize(15)
            joinButton.setTitle("\(String.fontAwesomeIconWithName(FontAwesome.Plus))  Join", forState: UIControlState.Normal)
        }
        newCommentField.delegate = self
        postCommentView.hidden = true
        Alamofire.request(.GET, Util.formatUrl("/games/\(game.id)/comments")).responseJSON{
            (req, res, json, err) in
            let resp: JSON? = JSON(json!)
            if let response = resp{
                for(key, comment) in response["comments"]{
                    self.comments.append(
                        Comment(body: comment["body"].string!,
                            author: Person(username: comment["author"]["username"].string!, id: comment["author"]["id"].int!, email: comment["author"]["email"].string!),
                            postedAt: comment["created_at"].string!.rails_date()))
                }
                self.tableView.reloadData()
            }
        }
        
        tableView = Util.initTableView(self, tableView: tableView)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = .None
        joinButton.rippleLayerColor = UIColor.whiteColor()
        gameContainer.layer.borderWidth = 1
        gameContainer.layer.cornerRadius = 2
        var image = UIImage(named: game.sport.name.lowercaseString+"_game_bg")
        if let img = image{
            bg.image = img
        }
        else{
            bg.image = UIImage(named: "sports")
        }
        bg.alpha = 0.2
        avatarIV.image = UIImage(named: "avatar")   
        titleLabel.text = game.title
        locationLabel.text = game.location
        timeLabel.text = game.datetime.string()
        createdByLabel.text = game.createdBy
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var count = comments.count > 0 ? comments.count : 1
        var mv = CGFloat(65*count)
        println(mv)
        self.view.animateViewMoving(true, moveValue: mv)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        postCommentView.hidden = true
        var count = comments.count > 0 ? comments.count : 1
        var mv = CGFloat(65*count)
        self.view.animateViewMoving(false, moveValue: mv)
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentsPlayersSC.selectedSegmentIndex == 0{
            return self.comments.count > 0 ? self.comments.count : 1
        }
        else{
            return self.game.players!.count > 0 ? self.game.players!.count : 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if commentsPlayersSC.selectedSegmentIndex == 0 && self.comments.count == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("player_game_cell", forIndexPath: indexPath) as! PlayerCell
            cell.playerLabel.text = "No comments"
            return cell
        }
        else if commentsPlayersSC.selectedSegmentIndex == 0{
            let comment = self.comments[indexPath.row]
            var cell = tableView.dequeueReusableCellWithIdentifier("util_game_cell", forIndexPath: indexPath) as! CommentCell
            cell.comment = comment
            cell.nameLabel.text = comment.author.username
            cell.bodyLabel.text = comment.body
             return cell
        }
        else{
            let player = self.game.players![indexPath.row]
            var cell = tableView.dequeueReusableCellWithIdentifier("player_game_cell", forIndexPath: indexPath) as! PlayerCell
            cell.playerLabel.text = player.username
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if commentsPlayersSC.selectedSegmentIndex == 0{
            return 65
        }
        else{
            return 35
        }
        
    }
    
    func addGameButtonClicked(){
        self.performSegueWithIdentifier("create_game_from_game", sender: self)
    }
    
    func hideKeyboard(){
        newCommentField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
