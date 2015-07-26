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
        sportSelector.hidden = false
        datePicker.hidden = true
        sportButton.setTitle(GlobalStorage.sports[0].capitalizedString, forState: UIControlState.Normal)
        locationInput.resignFirstResponder()
        titleInput.resignFirstResponder()
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        datePicker.addTarget(self, action: Selector("datePickerChanged"), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.title = "Create New Game"
        sportLabelIcon.makeIconLabel(FontAwesome.SpaceShuttle)
        titleIcon.makeIconLabel(FontAwesome.StarO)
        locationIcon.makeIconLabel(FontAwesome.MapMarker)
        timeIcon.makeIconLabel(FontAwesome.ClockO)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as! FirstViewController
        destination.newGameTitle = newGame["title"]
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalStorage.sports.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return GlobalStorage.sports[row].uppercaseString
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = GlobalStorage.sports[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newGame["sport"] = GlobalStorage.sports[row].lowercaseString
        sportButton.setTitle(GlobalStorage.sports[row], forState: UIControlState.Normal)
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
                    if let time = newGame["time"]{
                        saveButton.enabled = true
                        return true
                    }
                }
            }
        }
        saveButton.enabled = false
        return false
    }
    func createGame(){
        Game.create(newGame, callback: {
            (resp: JSON?) in
            if let response = resp{
                if response["status"].int! == 200{
                    self.performSegueWithIdentifier("create_success", sender: self)
                }
            }
        })
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
