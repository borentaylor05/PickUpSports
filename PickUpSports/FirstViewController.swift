//
//  FirstViewController.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/6/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import SwiftyJSON
import PusherSwift

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let pusher = Pusher(key: "78115fd80004e8bf53c9")
    
    var newGameTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // stores user in GlobalStorage.currentUser
        Util.saveCurrentUser()
        showNewGameModal()
        self.tabBarController?.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addGameButtonClicked"), animated: true)
        self.tabBarController?.navigationItem.title = "Available Games"
        tableView = Util.initTableView(self, tableView: tableView)
        let pusher = Pusher(key: "78115fd80004e8bf53c9", options: ["secret": "MY SECRET"])
        pusher.connect()
        let chan = pusher.subscribe("test-channel")
        
        
        chan.bind("test-event", callback: { (data: AnyObject?) -> Void in
            println(data)
            if let data = data as? Dictionary<String, AnyObject> {
                if let testVal = data["test"] as? String {
                    println(testVal)
                }
            }
        })
    }
    override func viewWillAppear(animated: Bool) {
        var spinner = self.view.addSpinner()
        spinner.color = UIColor.whiteColor()
        GlobalStorage.currentUser.setGames(){ (response) in            
            self.tableView.reloadData()
            spinner.remove()
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalStorage.currentUser.games.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("game_cell", forIndexPath: indexPath) as! GameCell
        let game = GlobalStorage.currentUser.games[indexPath.row]
        cell.formatGame(game)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_game"{
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let game = GlobalStorage.currentUser.games[indexPath!.row]
            var destination = segue.destinationViewController as! GameVC
            destination.game = game
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GameCell
        performSegueWithIdentifier("to_game", sender: cell)
    }
    
    func showNewGameModal(){
        if let title = newGameTitle{
            var message = "Game '\(title)' created successfully.  You will be alerted when someone joins your game."
            var settings = Modal.Settings()
            settings.overlayBlurStyle = .Dark
            settings.backgroundColor = UIColor(red: 200/255, green: 203/255, blue: 177/255, alpha: 0.5)
            settings.bodyColor = .whiteColor()
            Modal(title: "Success!", body: message, status: .Info, settings: settings).show()
        }
    }
    
    func addGameButtonClicked(){
        self.performSegueWithIdentifier("create_game_from_available_games", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

