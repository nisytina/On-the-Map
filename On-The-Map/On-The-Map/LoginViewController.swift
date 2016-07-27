//
//  ViewController.swift
//  On-The-Map
//
//  Created by 倪世莹 on 22/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //var appDelegate: AppDelegate!

    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //MARK: Notification 0
//        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
//        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
//        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
//        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
        errorMessage.text = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func login() {
        
        guard let email = EmailTextfield.text where EmailTextfield.text != ""
         else {
            performUIUpdatesOnMain{
                self.errorMessage.text = "Email can't be empty"
            }
            return
        }
        
        guard let password = PasswordTextfield.text where PasswordTextfield.text != ""
            else {
                performUIUpdatesOnMain{
                    self.errorMessage.text = "Password can't be empty"
                }
                return
        }
        self.errorMessage.text = ""
        UdacityClient.sharedInstance().createSession(email, password: password, errorMessage: errorMessage) {
            (SessionResults, error) in
            
            if let error = error {
                print(error)
                return
            } else {
                UdacityClient.sharedInstance().SessionID = SessionResults[UdacityJSONResponseKeys.SessionID]
                UdacityClient.sharedInstance().UserID = SessionResults[UdacityJSONResponseKeys.UserID
                ]
                
                UdacityClient.sharedInstance().getUserInfo {
                    (result, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if result as? Bool == true  {
                            //load map view
                            performUIUpdatesOnMain{
                                self.performSegueWithIdentifier("Map", sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func singup(sender: AnyObject) {
        let link = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
    UIApplication.sharedApplication().openURL(link!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Map" {
            
            let barViewControllers = segue.destinationViewController as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.topViewController as! MapViewController
            destinationViewController.message = "segue"
        }
        
    }

}



//extension LoginViewController: UITextFieldDelegate {
//    
//    // MARK: UITextFieldDelegate
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    // MARK: Show/Hide Keyboard
//    
//    func keyboardWillShow(notification: NSNotification) {
//        if !keyboardOnScreen {
//            view.frame.origin.y -= keyboardHeight(notification)
//            movieImageView.hidden = true
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if keyboardOnScreen {
//            view.frame.origin.y += keyboardHeight(notification)
//            movieImageView.hidden = false
//        }
//    }
//    
//    func keyboardDidShow(notification: NSNotification) {
//        keyboardOnScreen = true
//    }
//    
//    func keyboardDidHide(notification: NSNotification) {
//        keyboardOnScreen = false
//    }
//    
//    private func keyboardHeight(notification: NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.CGRectValue().height
//    }
//    
//    private func resignIfFirstResponder(textField: UITextField) {
//        if textField.isFirstResponder() {
//            textField.resignFirstResponder()
//        }
//    }
//    
//    @IBAction func userDidTapView(sender: AnyObject) {
//        resignIfFirstResponder(usernameTextField)
//        resignIfFirstResponder(passwordTextField)
//    }
//}

// MARK: - LoginViewController (Notifications)

extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



