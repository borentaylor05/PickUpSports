//
//  SportsTableViewController.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class SportsTableViewController: UITableViewController {
    
    @IBOutlet weak var infoBtn: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var editingSports = false
    var selectedSports = [String]()
    var joiner = " ~ "
    var errorColor: UIColor!
    var sportsNames = [String]()
    let colors = [UIColor.MKColor.DeepOrange, UIColor.MKColor.Cyan, UIColor.MKColor.Amber, UIColor.MKColor.BlueGrey, UIColor.MKColor.Lime, UIColor.MKColor.Blue, UIColor.MKColor.Indigo]

    override func viewDidLoad() {
        super.viewDidLoad()
        Sport.getAll(){ (response) in
            for(key, sport) in response["sports"]{
                self.sportsNames.append(sport["name"].string!.capitalizedString)
            }
            GlobalStorage.sports = self.sportsNames
            self.tableView.reloadData()
        }
        saveButton.enabled = false
        tableView.backgroundColor = UIColor.MKColor.Grey
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: UIImage(named: "sports"))
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        infoBtn.leftBarButtonItem?.title = String.fontAwesomeIconWithName(FontAwesome.Question)
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        GlobalStorage.currentUser.addSports(self.selectedSports){ (response) in
            if self.editingSports{
                self.performSegueWithIdentifier("to_settings", sender: self)
            }
            else{
                self.performSegueWithIdentifier("to_home", sender: self)
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("sport_header_cell") as! SportHeaderCell
        errorColor = headerCell.headerSubview.backgroundColor
        GlobalStorage.sportHeaderCell = headerCell
        GlobalStorage.sportHeaderCell.headerLabel.numberOfLines = 0
        return GlobalStorage.sportHeaderCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsNames.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("sport_cell", forIndexPath: indexPath) as! SportTableCell
        println(GlobalStorage.currentUser.sports)
        if editingSports{
            println(sportsNames[indexPath.row])
            if contains(GlobalStorage.currentUser.sports!, sportsNames[indexPath.row].lowercaseString){
                cell.formatCell(sportsNames[indexPath.row], status: .Selected)
                selectedSports.append(sportsNames[indexPath.row].lowercaseString)
            }
            else{
                cell.formatCell(sportsNames[indexPath.row], status: .NotSelected)
            }
        }
        else{
            cell.formatCell(sportsNames[indexPath.row], status: .NotSelected)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SportTableCell
        let index = find(selectedSports, cell.cellLabel.text!.lowercaseString)
        if contains(selectedSports, cell.cellLabel.text!.lowercaseString){
            cell.formatCell(cell.cellLabel.text!, status: .NotSelected)
            selectedSports.removeAtIndex(index!)
        }
        else{
            cell.formatCell(cell.cellLabel.text!, status: .Selected)
            selectedSports.append(cell.cellLabel.text!.lowercaseString)
        }
        if GlobalStorage.sportHeaderCell.headerLabel.text == "No sports selected..."{
            GlobalStorage.sportHeaderCell.headerLabel.text = cell.cellLabel.text
        }
        else{
            GlobalStorage.sportHeaderCell.headerLabel.text = joiner.join(selectedSports)
        }
        if selectedSports.count > 0{
            GlobalStorage.sportHeaderCell.headerSubview.backgroundColor = UIColor.MKColor.Green
            saveButton.enabled = true
        }
        else{
            saveButton.enabled = false
            GlobalStorage.sportHeaderCell.headerLabel.text = "No sports selected..."
            GlobalStorage.sportHeaderCell.headerSubview.backgroundColor = errorColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
