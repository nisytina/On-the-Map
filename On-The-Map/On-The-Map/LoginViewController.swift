//
//  ViewController.swift
//  On-The-Map
//
//  Created by Tina Ni on 22/7/2016.
//  Copyright © 2016 TinaNi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        PasswordTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
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
        
        guard let email = EmailTextfield.text where EmailTextfield.text != ""
         else {
            performUIUpdatesOnMain{
                Convenience.alert(self, title: "Error", message: "Email can't be empty", actionTitle: "Dismiss")
            }
            return
        }
        
        guard let password = PasswordTextfield.text where PasswordTextfield.text != ""
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
                if error.code == 2 {
                    print(error.domain)
                    performUIUpdatesOnMain {
                        self.loading.stopAnimating()
                        Convenience.alert(self, title: "Error", message: error.domain, actionTitle: "Try again")
                    }
                }
                print(error)
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
