//
//  CreateGameVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/24/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MaterialKit
import SwiftyJSON

class CreateGameVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var recognizer:UIGestureRecognizer!
    var newGame = [String:String]()
    var saveButton: UIBarButtonItem!
    var sportCities = "sports"
    var mySports: [String]!
    var myCities: [String]!
    let defaults = NSUserDefaults()

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sportLabelIcon: UILabel!
    @IBOutlet weak var sportSelector: UIPickerView!
    @IBOutlet weak var sportButton: MKButton!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleIcon: UILabel!
    @IBOutlet weak var locationIcon: UILabel!
    @IBOutlet weak var timeIcon: UILabel!
    @IBOutlet weak var timeButton: MKButton!
    @IBOutlet weak var cityButton: MKButton!
    @IBOutlet weak var cityIconLabel: MKLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.navigationController!.navigationItem.title)
        if self.navigationItem.title == "new"{
            self.navigationController?.navigationBarHidden = true
        }
        mySports = defaults.arrayForKey("sports") as! [String]
        myCities = defaults.arrayForKey("cities") as! [String]
        newGame["timeZone"] = GlobalStorage.timeZone
        saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "createGame")
        self.navigationItem.rightBarButtonItem = saveButton
        saveButton.enabled = false
        recognizer = UITapGestureRecognizer(target: self, action: "hidePickerAndKeyboard")
        sportSelector.delegate = self
        sportSelector.dataSource = self
        titleInput.delegate = self
        locationInput.delegate = self
        sportSelector.hidden = true
        datePicker.hidden = true
        titleInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        locationInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.addTarget(self, action: Selector("datePickerChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.title = "Create New Game"
        sportLabelIcon.makeIconLabel(FontAwesome.Trophy)
        titleIcon.makeIconLabel(FontAwesome.StarO)
        locationIcon.makeIconLabel(FontAwesome.MapMarker)
        timeIcon.makeIconLabel(FontAwesome.ClockO)
        cityIconLabel.makeIconLabel(FontAwesome.Building)
    }
    @IBAction func cityButtonTapped(sender: AnyObject) {
        sportCities = "cities"
        checkGameIsValid(newGame)
        locationInput.resignFirstResponder()
        titleInput.resignFirstResponder()
        sportSelector.selectRow(0, inComponent: 0, animated: true)
        sportSelector.hidden = false
        datePicker.hidden = true
        sportSelector.selectRow(0, inComponent: 0, animated: true)
        sportSelector.reloadAllComponents()
        cityButton.setTitle(myCities[0].capitalizedString, forState: UIControlState.Normal)
        newGame["city"] = myCities[0]
        checkGameIsValid(newGame)
    }
    @IBAction func timeButtonTapped(sender: AnyObject) {
        datePicker.hidden = false
        sportSelector.hidden = true
        locationInput.resignFirstResponder()
        titleInput.resignFirstResponder()
        view.addGestureRecognizer(recognizer)
    }
    @IBAction func locationButtonTapped(sender: AnyObject) {
        locationInput.hidden = false
        locationInput.becomeFirstResponder()
        view.addGestureRecognizer(recognizer)
    }
    @IBAction func titleButtonTapped(sender: AnyObject) {
        titleInput.hidden = false
        titleInput.becomeFirstResponder()
        view.addGestureRecognizer(recognizer)
    }
    @IBAction func sportSelectButton(sender: AnyObject) {
        titleView.frame = CGRectMake(titleView.frame.origin.x, 400, titleView.frame.size.width, titleView.frame.size.height)
        sportSelector.selectRow(0, inComponent: 0, animated: true)
        sportSelector.hidden = false
        sportCities = "sports"
        sportSelector.reloadAllComponents()
        datePicker.hidden = true
        sportButton.setTitle(mySports[0].capitalizedString, forState: UIControlState.Normal)
        newGame["sport"] = mySports[0]
        checkGameIsValid(newGame)
        locationInput.resignFirstResponder()
        titleInput.resignFirstResponder()
        view.addGestureRecognizer(recognizer)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as! FirstViewController
        destination.newGameTitle = newGame["title"]
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sportCities == "sports"{
            return mySports.count
        }
        else{
            return myCities.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if sportCities == "sports"{
            return mySports[row].capitalizedString
        }
        else{
            var parts = split(myCities[row]) {$0 == ","}
            return parts[0].capitalizedString+", "+parts[1].uppercaseString
        }
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let array = sportCities == "sports" ? mySports : myCities
        var titleData = array[row]
        if sportCities == "sports"{
            titleData = titleData.capitalizedString
        }
        else{
            titleData = titleData.cityState()
        }
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sportCities == "sports"{
            newGame["sport"] = mySports[row].lowercaseString
            sportButton.setTitle(mySports[row].capitalizedString, forState: UIControlState.Normal)
        }
        else{
            newGame["city"] = myCities[row].lowercaseString
            cityButton.setTitle(myCities[row].cityState(), forState: UIControlState.Normal)
        }
        checkGameIsValid(newGame)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        // 0 = title field - 1 = location field
        if textField.tag == 0{
            if textField.text.isEmpty{
                titleInput.hidden = true
            }
            else{
                newGame["title"] = textField.text
            }
        }
        else if(textField.tag == 1){
            if textField.text.isEmpty{
                locationInput.hidden = true
            }
            else{
                newGame["location"] = textField.text
            }
        }
        checkGameIsValid(newGame)
    }
    func hidePickerAndKeyboard(){
        self.sportSelector.hidden = true
        self.datePicker.hidden = true
        self.titleInput.resignFirstResponder()
        self.locationInput.resignFirstResponder()
    }
    func datePickerChanged(){
        var dateFormatter = NSDateFormatter()
        timeButton.setTitle(datePicker.date.string(), forState: UIControlState.Normal)
        newGame["time"] = datePicker.date.toRailsStringDate()
        checkGameIsValid(newGame)
    }
    
    func checkGameIsValid(game:[String:String]) -> Bool{
        if let sport = newGame["sport"] {
            if let title = newGame["title"]{
                if let location = newGame["location"]{
                    if let city = newGame["city"]{
                        if let time = newGame["time"]{
                            saveButton.enabled = true
                            return true
                        }
                    }
                }
            }
        }
        saveButton.enabled = false
        return false
    }
    func createGame(){
        var newGameObj = Game(title: newGame["title"]!,
                        location: newGame["location"]!,
                        city: newGame["city"]!.toCity(),
                        datetime: datePicker.date,
                        sport: Sport(name: newGame["sport"]!),
                        createdBy: GlobalStorage.currentUser.username
            )
        newGameObj.create(){ (response) in
            if response["status"].int! == 200{
                self.performSegueWithIdentifier("create_success", sender: self)
            }
        }
    }
    
    func placeholder(){
        // nothing to do
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
