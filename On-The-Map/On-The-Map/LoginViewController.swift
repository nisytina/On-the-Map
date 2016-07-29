//
//  ViewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 22/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        passwordTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        loading.stopAnimating()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func login() {
        
        // hide keyborad before login
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
        
        guard let email = emailTextfield.text where emailTextfield.text != ""
         else {
            performUIUpdatesOnMain{
                Convenience.alert(self, title: "Error", message: "Email can't be empty", actionTitle: "Dismiss")
            }
            return
        }
        
        guard let password = passwordTextfield.text where passwordTextfield.text != ""
            else {
                performUIUpdatesOnMain{
                    Convenience.alert(self, title: "Error", message: "Password can't be empty", actionTitle: "Dismiss")
                }
                return
        }
        loading.startAnimating()
        UdacityClient.sharedInstance().createSession(email, password: password) {
            (SessionResults, error) in
            
            if let error = error {
                var message: String
                if error.code == 2 {
                    message = error.domain
                } else if error.code == -1009 {
                    message = "connection fails"
                } else {
                    message = error.domain
                }
                print(error)
                performUIUpdatesOnMain {
                    self.loading.stopAnimating()
                    Convenience.alert(self, title: "Error", message: message, actionTitle: "Try again")
                }
            } else{
                UdacityClient.sharedInstance().SessionID = SessionResults[UdacityJSONResponseKeys.SessionID]
                UdacityClient.sharedInstance().UserID = SessionResults[UdacityJSONResponseKeys.UserID
                ]
                UdacityClient.sharedInstance().getUserInfo {
                    (result, error) in
                    if let error = error {
                        self.loading.stopAnimating()
                        print(error)
                    } else {
                        if result as? Bool == true  {
                            //load map view
                            performUIUpdatesOnMain{
                                self.loading.stopAnimating()
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

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
