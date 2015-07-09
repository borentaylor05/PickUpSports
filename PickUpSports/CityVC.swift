//
//  CityVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CityVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var resultSearchController = UISearchController()
    
    var filterCities = [City]()
    var cities = [
        City(name:"Parker", state:"CO"),
        City(name:"Lone Tree", state:"CO"),
        City(name:"Centennial", state:"CO"),
        City(name:"Aurora", state:"CO"),
        City(name:"Denver", state:"CO"),
        City(name:"Castle Rock", state:"CO"),
        City(name:"Englewood", state:"CO"),
        City(name:"Highlands Ranch", state:"CO")
    ]
    
    var cityStrings = [String]()
    var filteredCityStrings = [String]()
    var joiner = " ~ "
    var citiesFollowing = [City]()
    var cityNames = [String]()
    var cityHeaderTapRecognizer: UIGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.enabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.MKColor.Grey
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: UIImage(named: "sports"))
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        for city in cities{
            cityStrings.append(city.name+", "+city.state)
        }
        filteredCityStrings = cityStrings
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredCityStrings.count
        } else {
            return self.cities.count
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("city_header_cell") as! CityHeaderCell
        GlobalStorage.errorColor = headerCell.chSubview.backgroundColor
        GlobalStorage.cityHeaderCell = headerCell
        GlobalStorage.cityHeaderCell.chLabel.numberOfLines = 0
        cityHeaderTapRecognizer = UITapGestureRecognizer(target: GlobalStorage.cityHeaderCell, action: Selector("headerTapped"))
        cityHeaderTapRecognizer.delegate = GlobalStorage.cityHeaderCell
        GlobalStorage.cityHeaderCell.addGestureRecognizer(cityHeaderTapRecognizer)
        return GlobalStorage.cityHeaderCell
    }
    
    func headerTapped(){
        println("KNOCK")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SportTableCell
        var parts = cell.cityLabel.text!.componentsSeparatedByString(",")
        if parts.count > 0{
            if !contains(cityNames, parts[0].trim()){
                let city = City(name: parts[0].trim(), state: parts[1].trim())
                citiesFollowing.append(city)
                cityNames.append(parts[0].trim())
                cell.rippleLayerColor = UIColor.greenColor()
                cell.cityPlus.textColor = UIColor.greenColor()
                cell.cityPlus.text = String.fontAwesomeIconWithName(FontAwesome.Check)
            }
            else{
                for (index, city) in enumerate(citiesFollowing){
                    if city.name == parts[0].trim(){
                        citiesFollowing.removeAtIndex(index)
                        cityNames.removeAtIndex(index)
                        cell.rippleLayerColor = UIColor.whiteColor()
                        cell.cityPlus.textColor = UIColor.whiteColor()
                        cell.cityPlus.text = String.fontAwesomeIconWithName(FontAwesome.Plus)
                    }
                }
            }
        }
        if citiesFollowing.count > 0{
            nextButton.enabled = true
            GlobalStorage.cityHeaderCell.chSubview.backgroundColor = GlobalStorage.successColor
            GlobalStorage.cityHeaderCell.chLabel.text = joiner.join(self.cityNames)
        }
        else{
            nextButton.enabled = false
            GlobalStorage.cityHeaderCell.chSubview.backgroundColor = GlobalStorage.errorColor
            GlobalStorage.cityHeaderCell.chLabel.text = "No cities selected..."
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("city_cell", forIndexPath: indexPath) as! SportTableCell
        if self.resultSearchController.active{
            cell.formatCity(cell, text: filteredCityStrings[indexPath.row])
        }
        else{
            if GlobalStorage.cityHeaderCell != nil{
                GlobalStorage.cityHeaderCell.hidden = false
            }
            cell.formatCity(cell, text: cityStrings[indexPath.row])
        }
        var parts = cell.cityLabel.text!.componentsSeparatedByString(",")
        if parts.count > 0{
            for city in citiesFollowing{
                if city.name == parts[0].trim(){
                    cell.cityPlus.textColor = UIColor.greenColor()
                    cell.cityPlus.text = String.fontAwesomeIconWithName(FontAwesome.Check)
                    break
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        filteredCityStrings.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (cityStrings as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredCityStrings = array as! [String]
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
