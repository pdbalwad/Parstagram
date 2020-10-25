//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Priyanka Balwadkar on 10/24/20.
//

import UIKit
import Parse


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onSignIn(_ sender: Any) {
        let uname = username.text!
        let password = passwordTextField.text!
        PFUser.logInWithUsername(inBackground:uname, password:password) {
          (user, error) in
          if user != nil {
            // Do stuff after successful login.
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
            // The login failed. Check error to see why.
            print("Error: \(error?.localizedDescription)")
          }
        }

        
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user.username = username.text
        user.password = passwordTextField.text
         //user.email = "email@example.com"
         // other fields can be set just like with PFObject
         //user["phone"] = "415-392-0202"
        user.signUpInBackground { (success, error) in
            if success{
                self.username.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "loginSegue", sender:  nil)
            }
            else{
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
