//
//  Util.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import SwiftyJSON
import FontAwesome_swift

typealias ApiResponse = (JSON) -> Void

class Util {
    static func initTableView(controller: AnyObject?, tableView: UITableView) -> UITableView{
        tableView.delegate = controller as? UITableViewDelegate
        tableView.dataSource = controller as? UITableViewDataSource
        tableView.backgroundColor = UIColor.MKColor.Grey
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: GlobalStorage.backgroundImage)
        return tableView
    }
    
    static func saveCurrentUser(){
        let defaults = NSUserDefaults()
        GlobalStorage.currentUser = Person(username: defaults.objectForKey("username") as! String!,
            id: defaults.objectForKey("user_id") as! Int!,
            email: defaults.objectForKey("email") as! String!,
            token: defaults.objectForKey("token") as! String!
        )
        GlobalStorage.currentUser.setCities()
        GlobalStorage.currentUser.setSports()
    }
    
    static func saveCurrentUserNoCitySports(){
        let defaults = NSUserDefaults()
        GlobalStorage.currentUser = Person(username: defaults.objectForKey("username") as! String!,
            id: defaults.objectForKey("user_id") as! Int!,
            email: defaults.objectForKey("email") as! String!,
            token: defaults.objectForKey("token") as! String!
        )
    }
    
    static func formatUrl(resource:String) -> String{
        let defaults = NSUserDefaults()
        let currentAuth = "?user_email="+GlobalStorage.currentUser.email+"&user_token="+GlobalStorage.currentUser.token
        return "\(GlobalStorage.url)\(resource)\(currentAuth)"
    }
    
    static func isSmallDevice() -> Bool{
        let device = Device()
        let smallDevices = [Device.Simulator, Device.iPhone5s, Device.iPhone5c, Device.iPhone5, Device.iPhone4s, Device.iPhone4, Device.iPodTouch5]
        if contains(smallDevices, device){
            return true
        }
        else{
            return false
        }
    }
    
}

extension String{
    func trim() -> String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    func rails_date() -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(self)
        return date!
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    func cityState() -> String{
        var parts = split(self) {$0 == ","}
        return parts[0].capitalizedString+", "+parts[1].uppercaseString
    }
    func toCity() -> City{
        var parts = split(self) {$0 == ","}
        return City(name: parts[0], state: parts[1])
    }
}

extension NSDate{
    
    func string() -> String{
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(self)
    }
    func toRailsStringDate() -> String{
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.stringFromDate(self)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        var border = CALayer()
        
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
}

extension UIView {
    func addSpinner() -> UIActivityIndicatorView{
        var view = self
        //instantiate a gray Activity Indicator View
        var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        //add the activity to the ViewController's view
        view.addSubview(activityIndicatorView)
        //position the Activity Indicator View in the center of the view
        activityIndicatorView.center = view.center
        //tell the Activity Indicator View to begin animating
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.frame = CGRectOffset(self.frame, 0,  movement)
        UIView.commitAnimations()
    }
}

extension UILabel{
    func makeIconLabel(icon:FontAwesome){
        var label = self
        label.layer.addBorder(UIRectEdge.Right, color: UIColor(rgba: "#AAAAAA"), thickness: 1)
        label.font = UIFont.fontAwesomeOfSize(18)
        label.textColor = UIColor(rgba: "#555555")
        label.text = String.fontAwesomeIconWithName(icon)
    }
}

extension UIActivityIndicatorView{
    func remove(){
        self.removeFromSuperview()
    }
}

extension NSUserDefaults{
    func clear(){
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
}

protocol UserSettings {
    static func getAll(callback:ApiResponse)
}




