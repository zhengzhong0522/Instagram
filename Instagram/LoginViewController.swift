//
//  LoginViewController.swift
//  Instagram
//
//  Created by zhong zheng on 2/4/21.
//  Copyright © 2021 ZHONG ZHENG. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
           if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
               performSegue(withIdentifier: "loginSegue", sender: self)
           }
       }
    
    @IBAction func onSignin(_ sender: Any) {
        let username = usernameField.text!
               let password = passwordField.text!
               PFUser.logInWithUsername(inBackground: username, password: password) { (user, Error) in
                   if user != nil{
                       UserDefaults.standard.set(true, forKey: "userLoggedIn")
                       self.performSegue(withIdentifier: "loginSegue", sender: nil)
                   }else {
                        print("Error: \(Error?.localizedDescription)")
                   }
               }
    }
    
    @IBAction func onSignup(_ sender: Any) {
        var user = PFUser()

        user.username = usernameField.text
        user.password = passwordField.text
        user.signUpInBackground { (success, error) in
            if success {
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
