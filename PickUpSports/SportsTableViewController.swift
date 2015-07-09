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

class SportsTableViewController: UITableViewController {
    
    @IBOutlet weak var infoBtn: UINavigationItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        let joiner = ", "
        var body = " Select all the sports you play. \n You will get notifications for any pick up games in your current city for all sports you select here. \n These sports can be added or removed from the settings tab at any time."
        var settings = Modal.Settings()
        settings.backgroundColor = .whiteColor()
        settings.shadowType = .Curl
        settings.shadowRadius = CGFloat(5)
        settings.shadowOffset = CGSize(width: 0, height: -3)
        settings.overlayBlurStyle = .Dark
        
        Modal(title: "You're Almost Ready to Go!", body: body, status: .Warning, settings: settings).show()
    }
    
    var selectedSports = [String]()
    var joiner = " ~ "
    var errorColor: UIColor!
    let sportsNames = ["Basketball", "Football", "Soccer", "Hockey", "Softball/Baseball", "Golf", "Hockey", "Hockey", "Hockey", "Hockey", "Hockey", "Hockey"]
    let colors = [UIColor.MKColor.DeepOrange, UIColor.MKColor.Cyan, UIColor.MKColor.Amber, UIColor.MKColor.BlueGrey, UIColor.MKColor.Lime, UIColor.MKColor.Blue, UIColor.MKColor.Indigo]

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        tableView.backgroundColor = UIColor.MKColor.Grey
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: UIImage(named: "sports"))
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        infoBtn.leftBarButtonItem?.title = String.fontAwesomeIconWithName(FontAwesome.Question)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
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
        cell = cell.formatSport(cell, text: sportsNames[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SportTableCell
        let index = find(selectedSports, cell.cellLabel.text!)
        if contains(selectedSports, cell.cellLabel.text!){
            cell.rippleLayerColor = UIColor.whiteColor()
            cell.plus.text = String.fontAwesomeIconWithName(FontAwesome.Plus)
            cell.plus.textColor = UIColor.whiteColor()
            cell.rippleLayerColor = UIColor.whiteColor()
            selectedSports.removeAtIndex(index!)
        }
        else{
            cell.plus.text = String.fontAwesomeIconWithName(FontAwesome.Check)
            cell.plus.textColor = UIColor.greenColor()
            cell.rippleLayerColor = UIColor.greenColor()
            selectedSports.append(cell.cellLabel.text!)
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
