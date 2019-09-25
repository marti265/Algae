//
//  ViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 9/30/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData
import SwiftCharts

class DataEntryViewControllerBase: UIViewController, UITextFieldDelegate {
    
    var currentTextField: UITextField!
    var uiToolbar: UIToolbar!
    
    var dataEntryVals: [String:Float] = [:]
    var logID: NSManagedObjectID?
    var validChl = false
    var validPO4 = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.uiToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        self.uiToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.dismissKeyboard))
        let next: UIBarButtonItem  = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextField))
        
        var items = [UIBarButtonItem]()
        items.append(done)
        items.append(flexSpace)
        items.append(next)
        
        self.uiToolbar.items = items
        self.uiToolbar.sizeToFit()
        
        registerForKeyboardNotifications()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dismissKeyboard()
    
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let currentField = self.currentTextField {
            if (!aRect.contains(currentField.frame.origin)){
                self.scrollView.scrollRectToVisible(currentField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height - 100, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        self.currentTextField = nil
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func nextField() {
        // Try to find next responder
        if let nextField = currentTextField.superview?.viewWithTag(currentTextField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
    }
    
}
