//
//  Util.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/7/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FontAwesome_swift

class Util {
    static func initTableView(controller: AnyObject?, tableView: UITableView) -> UITableView{
        tableView.delegate = controller as? UITableViewDelegate
        tableView.dataSource = controller as? UITableViewDataSource
        tableView.backgroundColor = UIColor.MKColor.Grey
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundView = UIImageView(image: GlobalStorage.backgroundImage)
        return tableView
    }
    
    static func saveCurrentUser(view:UIViewController){
        Alamofire.request(.GET, GlobalStorage.url+"/users/current\(GlobalStorage.currentAuth)").responseJSON{
            (req, resp, json, error) in
            let resp: JSON? = JSON(json!)
            if let response = resp{
                println(response)
                GlobalStorage.currentUser = Person(username: response["user"]["username"].string!,
                    id: response["user"]["id"].int!,
                    email: response["user"]["email"].string!,
                    token: response["user"]["authentication_token"].string!
                )
                view.performSegueWithIdentifier("login_successful", sender: view)
            }
        }
    }
    
    static func formatUrl(resource:String) -> String{
        return "\(GlobalStorage.url)\(resource)\(GlobalStorage.currentAuth)"
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