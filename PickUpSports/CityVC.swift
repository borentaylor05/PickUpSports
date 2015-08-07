//
//  CityVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class CityVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var editingCities = false
    var resultSearchController = UISearchController()
    var filterCities = [City]()
    var cities = [City]()
    var citiesFollowing = [City]()
    var citiesFollowingStrings = [String]()
    var cityStrings = [String]()
    var filteredCityStrings = [String]()
    var joiner = " ~ "
    var cityNames = [String]()
    var cityHeaderTapRecognizer: UIGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // stores user in GlobalStorage.currentUser
        if !self.editingCities{
            Util.saveCurrentUserNoCitySports()
        }
        else{
            nextButton.title = "Save"
        }
        nextButton.enabled = false
        tableView = Util.initTableView(self, tableView: tableView)
        City.getAll(){ (response) in
            for(key, q) in response["cities"]{
                self.cities.append(City(name: q["name"].string!.capitalizedString, state: q["state"].string!.uppercaseString))
            }
            self.resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.hidesNavigationBarDuringPresentation = false
                controller.dimsBackgroundDuringPresentation = false
                controller.searchBar.sizeToFit()
                self.tableView.tableHeaderView = controller.searchBar
                return controller
            })()
            for city in self.cities{
                self.cityStrings.append(city.name+", "+city.state)
            }
            self.filteredCityStrings = self.cityStrings
            self.tableView.reloadData()
        }
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        GlobalStorage.currentUser.addCities(self.citiesFollowingStrings){ (response) in
            // empty callback - nothing to do
        }
        if self.editingCities{
            performSegueWithIdentifier("to_settings", sender: self)
        }
        else{
            performSegueWithIdentifier("to_sports", sender: self)
        }
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
        GlobalStorage.cityHeaderCell = headerCell
        GlobalStorage.cityHeaderCell.chLabel.numberOfLines = 0
        cityHeaderTapRecognizer = UITapGestureRecognizer(target: GlobalStorage.cityHeaderCell, action: Selector("headerTapped"))
        cityHeaderTapRecognizer.delegate = GlobalStorage.cityHeaderCell
        GlobalStorage.cityHeaderCell.addGestureRecognizer(cityHeaderTapRecognizer)
        if self.editingCities{
            GlobalStorage.cityHeaderCell.chSubview.backgroundColor = GlobalStorage.successColor
            GlobalStorage.cityHeaderCell.chLabel.text = "No new cities selected..."
        }
        return GlobalStorage.cityHeaderCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SportTableCell
        var parts = cell.cityLabel.text!.componentsSeparatedByString(",")
        if parts.count > 0{
            if !contains(cityNames, parts[0].trim()){
                let city = City(name: parts[0].trim(), state: parts[1].trim())
                citiesFollowing.append(city)
                citiesFollowingStrings.append(parts[0]+","+parts[1])
                cityNames.append(parts[0].trim())
                cell.formatCell(parts[0]+","+parts[1], status: .Selected)
            }
            else{
                for (index, city) in enumerate(citiesFollowing){
                    if city.name.lowercaseString == parts[0].lowercaseString.trim(){
                        citiesFollowing.removeAtIndex(index)
                        citiesFollowingStrings.removeAtIndex(index)
                        cityNames.removeAtIndex(index)
                        cell.formatCell(parts[0]+","+parts[1], status: .NotSelected)
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
            cell.formatCell(filteredCityStrings[indexPath.row], status: .NotSelected)
        }
        else{
            if GlobalStorage.cityHeaderCell != nil{
                GlobalStorage.cityHeaderCell.hidden = false
            }
            cell.formatCell(cityStrings[indexPath.row], status: .NotSelected)
        }
        var parts = cell.cityLabel.text!.componentsSeparatedByString(",")
        if parts.count > 0{
            if self.editingCities{
                GlobalStorage.cityHeaderCell.chLabel.text = "No new cities selected"
                println(GlobalStorage.currentUser.cities)
                if let myCities = GlobalStorage.currentUser.cities{
                    for city in myCities{
                        var cityParts = city.componentsSeparatedByString(",")
                        if cityParts[0].lowercaseString.trim() == parts[0].lowercaseString.trim(){
                            cell.formatCell(city, status: .Selected)
                            citiesFollowingStrings.append(city)
                            citiesFollowing.append(City(name: parts[0], state: parts[1]))
                            cityNames.append(cityParts[0].capitalizedString)
                            nextButton.enabled = true
                            break
                        }
                    }
                }
            }
            else{
                for city in citiesFollowing{
                    if city.name == parts[0].trim(){
                        cell.status = .Selected
                        break
                    }
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

}
