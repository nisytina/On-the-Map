//
//  ViewController.swift
//  On-The-Map
//
//  Created by 倪世莹 on 22/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var appDelegate: AppDelegate!

    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        createSession(email, password: password)
        
    }
    
    func createSession(email: String, password: String) {

        let request = NSMutableURLRequest(URL: NSURL(string: UdacityMethods.Session)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"\(UdacityJSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityJSONBodyKeys.Password)\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                print("Your request returned a status code other than 2xx!")
//                return
//            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            /* 5A. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            /* GUARD: Did Udacity return an error? */
            if let _ = parsedResult[UdacityJSONResponseKeys.StatusCode] as? Int {
                performUIUpdatesOnMain {
                   if let error = parsedResult[UdacityJSONResponseKeys.StatusMessage]! {
                    self.errorMessage.text =
                        error as? String
                    }
                    
                }
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let account = parsedResult[UdacityJSONResponseKeys.Account] as? [String:AnyObject] else {
                print("Cannot find account info")
                return
            }
            
            /* GUARD: Is the session created sucessfully?  */
            guard let session = parsedResult[UdacityJSONResponseKeys.Session] as? [String:String] else {
                print("Cannot create new session")
                return
            }
            
            /* 6A. Use the data! */
            if account[UdacityJSONResponseKeys.Registration] as! Bool == true {
                self.appDelegate.sessionID = session[UdacityJSONResponseKeys.SessionID]
                self.appDelegate.userID = account[UdacityJSONResponseKeys.UserID] as? String
                
            }
            
            print(self.appDelegate.sessionID)
            print(self.appDelegate.userID)
            
            // load map view
            

        }
        task.resume()
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



