//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var loginFailedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginFailedLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        // Shows a loading indicator from "SVProgressHUD"
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                
                SVProgressHUD.dismiss()
                self.loginFailedLabel.text = "Login failed."
                
                print(error!)
                
            } else {
                
                print("Login was successful!")
                
                // Dismisses the loading indicatory from "SVProgressHUD"
                SVProgressHUD.dismiss()
                
                self.emailTextfield.resignFirstResponder()
                self.passwordTextfield.resignFirstResponder()
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
            
        }
        
    }
    


    
}  
