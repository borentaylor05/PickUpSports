//
//  CreateAccountVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/26/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit
import FontAwesome_swift
import Alamofire
import SwiftyJSON

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    
    var credentials = [String:String]()
    var recognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var usernameButton: MKButton!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var usernameIcon: MKLabel!
    
    @IBOutlet weak var emailButton: MKButton!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailIcon: MKLabel!
    
    @IBOutlet weak var passwordButton: MKButton!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordIcon: MKLabel!

    @IBOutlet weak var confirmPasswordButton: MKButton!
    @IBOutlet weak var confirmPasswordInput: UITextField!
    @IBOutlet weak var confirmPasswordIcon: MKLabel!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pwError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.delegate = self
        passwordInput.delegate = self
        confirmPasswordInput.delegate = self
        emailInput.delegate = self
        createButton.enabled = false
        errorLabel.numberOfLines = 0
        recognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        view.addGestureRecognizer(recognizer)
        usernameInput.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        passwordInput.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        confirmPasswordInput.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        emailInput.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        emailInput.addTarget(self, action:"checkEmail:", forControlEvents:.EditingChanged)
        usernameInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        passwordInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        confirmPasswordInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        emailInput.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        usernameIcon.makeIconLabel(FontAwesome.User)
        emailIcon.makeIconLabel(FontAwesome.Envelope)
        passwordIcon.makeIconLabel(FontAwesome.Lock)
        confirmPasswordIcon.makeIconLabel(FontAwesome.Lock)
    }
    
    @IBAction func usernameButtonTapped(sender: AnyObject) {
        usernameInput.hidden = false
        usernameInput.becomeFirstResponder()
    }
    @IBAction func emailButtonTapped(sender: AnyObject) {
        emailInput.hidden = false
        emailInput.becomeFirstResponder()
    }
    @IBAction func passwordButtonTapped(sender: AnyObject) {
        passwordInput.hidden = false
        passwordInput.becomeFirstResponder()
    }
    @IBAction func confirmPasswordTapped(sender: AnyObject) {
        confirmPasswordInput.hidden = false
        confirmPasswordInput.becomeFirstResponder()
        if Util.isSmallDevice(){
            self.view.animateViewMoving(true, moveValue: 50)
        }
    }
    @IBAction func createButtonTapped(sender: AnyObject) {
        Alamofire.request(.POST, GlobalStorage.url+"/users", parameters: credentials, encoding: .JSON).responseJSON{
            (req, resp, json, err) in
            let resp: JSON? = JSON(json!)
            if let response = resp{
                println(response)
                if response["status"] == 200{
                    
                }
                else{
                    self.errorLabel.text = ""
                    var errors = response["error"].array!
                    for err in errors{
                        self.errorLabel.text = self.errorLabel.text! + err.string!
                    }
                    self.errorLabel.hidden = false
                }
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.isEmpty{
            textField.hidden = true
        }
        if Util.isSmallDevice() && textField.tag == 3{
            self.view.animateViewMoving(false, moveValue: 50)
        }
    }
    
    func inputChanged(textField: UITextField) {
        if !textField.text.isEmpty{
            if textField.tag == 0{
                credentials["username"] = textField.text.trim()
            }
            else if(textField.tag == 1){
                credentials["email"] = textField.text.trim()
            }
            else if(textField.tag == 2){
                credentials["password"] = nil
                if count(textField.text) >= 6 {
                    credentials["password"] = textField.text.trim()
                }
            }
            else if(textField.tag == 3){
                credentials["confirmPassword"] = nil
                if count(textField.text) >= 6 {
                    credentials["confirmPassword"] = textField.text.trim()
                }
            }
        }
        checkFormIsValid(credentials)
    }
    
    func checkEmail(email:UITextField){
        if email.text.isValidEmail(){
            emailError.hidden = true
        }
        else{
            createButton.enabled = false
            emailError.hidden = false
        }
    }
    
    func checkFormIsValid([String:String]) -> Bool{
        if let username = credentials["username"]{
            if let email = credentials["email"]{
                if let pw = credentials["password"]{
                    if let pwc = credentials["confirmPassword"]{
                        if pw == pwc{
                            pwError.hidden = true
                            errorLabel.hidden = true
                            if email.isValidEmail(){
                                createButton.enabled = true
                                return true
                            }
                        }
                        else{
                            pwError.hidden = false
                        }
                    }
                }
            }
        }
        createButton.enabled = false
        return false
    }
    
    func hideKeyboard(){
        usernameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        confirmPasswordInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    
    func placeholder(){
        // nothing to do
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
