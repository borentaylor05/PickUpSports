//
//  FirstViewController.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/6/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var games = [Game]()
    var newGameTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNewGameModal()
        self.tabBarController?.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addGameButtonClicked"), animated: true)
        self.tabBarController?.navigationItem.title = "Available Games"
        tableView = Util.initTableView(self, tableView: tableView)
        
    }
    override func viewWillAppear(animated: Bool) {
        games = []
        var spinner = self.view.addSpinner()
        spinner.color = UIColor.whiteColor()
        Alamofire.request(.GET, GlobalStorage.url+"/users/\(GlobalStorage.currentUser.id!)/games\(GlobalStorage.currentAuth)").responseJSON{
            (req, resp, json, err) in
            let resp: JSON? = JSON(json!)
            if let response = resp{
                for(key, game) in response["games"]{
                    var g = self.jsonToGame(game)
                    var players = [Person]()
                    for(key, player) in game["players"]{
                        players.append(Person(username: player["username"].string!, id: player["id"].int!, email: player["email"].string!))
                    }
                    g.players = players
                    g.playersNeeded = g.playersNeeded - g.players!.count - 1
                    self.games.append(g)
                }
                self.tableView.reloadData()
                spinner.remove()
            }
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("game_cell", forIndexPath: indexPath) as! GameCell
       // let recognizer = UITapGestureRecognizer(target: self, action: Selector("gameCellTapped"))
        let game = games[indexPath.row]
       // recognizer.delegate = cell
       // cell.addGestureRecognizer(recognizer)
        cell.formatGame(game)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_game"{
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let game = games[indexPath!.row]
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
    
    func jsonToGame(game:JSON) -> Game{
        return Game(title: game["title"].string!,
            location: game["location"].string!,
            city: City(name: game["city"]["name"].string!, state: game["city"]["state"].string!),
            datetime: game["time"].string!.rails_date(),
            sport: Sport(name: game["sport"]["name"].string!),
            playersNeeded: game["players_needed"].int!,
            createdBy: game["owner"].string!,
            id: game["id"].int!,
            joined: game["joined"].bool!
        )
    }
    
    func addGameButtonClicked(){
        self.performSegueWithIdentifier("create_game_from_available_games", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

