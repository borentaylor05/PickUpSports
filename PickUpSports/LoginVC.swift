//
//  LoginVC.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/19/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import FontAwesome_swift

class LoginVC: UIViewController, UITextFieldDelegate {

    var credentials = [String:String]()
    var recognizer: UITapGestureRecognizer!
    @IBOutlet weak var usernameTextField: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var usernameIcon: UILabel!
    @IBOutlet weak var pwIcon: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        passwordTextField.addTarget(self, action:"inputChanged:", forControlEvents:.EditingChanged)
        usernameTextField.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        passwordTextField.addTarget(self, action:"placeholder", forControlEvents:.EditingDidEndOnExit)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        recognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(recognizer)
        submitButton.enabled = false
        usernameIcon.makeIconLabel(FontAwesome.User)
        pwIcon.makeIconLabel(FontAwesome.Lock)
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
    }
    @IBAction func passwordButtonTapped(sender: AnyObject) {
        passwordTextField.hidden = false
        passwordTextField.becomeFirstResponder()
        if usernameTextField.text.isEmpty{
            usernameTextField.hidden = true
        }
    }
    @IBAction func usernameButtonTapped(sender: AnyObject) {
        usernameTextField.hidden = false
        usernameTextField.becomeFirstResponder()
        if passwordTextField.text.isEmpty{
            passwordTextField.hidden = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        if textField.text.isEmpty{
            textField.hidden = true
        }
        else{
            if textField.tag == 0{
                credentials["username"] = textField.text
            }
            else if(textField.tag == 1){
                credentials["password"] = textField.text
            }
        }
        checkFormIsValid(credentials)
    }
    
    func inputChanged(textField: UITextField) {
        if !textField.text.isEmpty{
            if textField.tag == 0{
                credentials["username"] = textField.text
            }
            else if(textField.tag == 1){
                credentials["password"] = nil
                if count(textField.text) >= 6{
                    credentials["password"] = textField.text
                }
            }
        }
        checkFormIsValid(credentials)
    }
    
    func checkFormIsValid([String:String]) -> Bool{
        if let username = credentials["username"]{
            if let pw = credentials["password"]{
                println(pw)
                submitButton.enabled = true
                return true
            }
        }
        submitButton.enabled = false
        return false
    }
    
    func hideKeyboard(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if usernameTextField.text.isEmpty{
            usernameTextField.hidden = true
        }
        if passwordTextField.text.isEmpty{
            passwordTextField.hidden = true
        }
    }
    
    func placeholder(){
        // nothing to do
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
