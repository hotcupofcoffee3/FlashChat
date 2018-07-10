//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // Declare instance variables here
    var messageArray = [Message]()
    
    // We've pre-linked the IBOutlets
    
    // This height constraint is linked to the messageTextField area
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        
        // Already done in Storyboard
//        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        // *****
        // ***** Have to register this information for your table view if you have custom cells
        // *****
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // This calls our declared function and configures the table view to be set at a height that works with the custom cell above.
        configureTableView()
        
        // This calls our declared function and gets all of the messages that have been saved to the database.
        retrieveMessages()
        
        // Removes the little grey lines between cells in the table view
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This custom message cell was created with the "CustomMessageCell.swift" Cocoa Touch Class as a 'TableViewCell' with a subclass of the 'UITableViewCell' class.
        // You also have to tick the "Also create XIB file" below it, to create the custom cell. This creates a XIB file with a container that will be used to stylize the custom cell.
        // This is then linked up to our custom cell design created as the "MessageCell.xib" (pron. 'zib') file.
        // ***** When you create one, you also have to REGISTER it, as above in the 'viewDidLoad' method.
        // The custom cell in "MessageCell.xib" is set to have the class of "CustomMessageCell.swift" and given an identifier of "customMessageCell".
        // With this information, we don't use the default cell style that has been used before, called 'let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")'. That's how we have done it in the past.
        // This time you choose to dequeue a particular type of cell with the identifier we created, and used "indexPath" as the Index Path (not 'indexPath.row', as this returns the number of the row in the array, not the actual row itself, which is what we need with the 'indexPath' parameter.
        // Finally, after saying we are using a particular custom cell with our unique identifier of "customMessageCell", we have to cast it as our class that we created for the custom cell in the "MessageCell.xib" file, which is the "CustomMessageCell" class.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    
    //TODO: Declare tableViewTapped here:
    
    // Needed "@objc" in front of this because the function above that calls this as the "#selector" is related to Objective-C, not Swift.
    @objc func tableViewTapped() {
        
        // This means signals that the text field has ended editing.
        // This is different from "resignFirstResponder()" in that this one simply signifies that editing has ended (and therefore triggers our "textFieldDidEndEditing()" function below), while "resignFirstResponder()" closes the keyboard and signifies that editing has ended, and therefore triggers our function, as well.
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    // This is a custom function that we made.
    func configureTableView() {
        
        // Sets the row height of the table to be automatic
        messageTableView.rowHeight = UITableViewAutomaticDimension
        
        // Arbitrary dimensions that simply set the height to something. It doesn't seem to matter what it's set at, it automatically adjusts to our custom cell. However, if it isn't set at all, then the automatic resizing does not work.
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    
    //MARK:- TextField Delegate Methods
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    
    // KEYBOARD IS 258pts HIGH
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Animates the change in 0.5 seconds
        UIView.animate(withDuration: 0.5) {
            
            // Keyboard height + set height constraint of 50
            self.heightConstraint.constant = 258 + 50
            
            // This redraws the view layout if something changes
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Animates the change in 0.5 seconds
        UIView.animate(withDuration: 0.5) {
            
            // Set back to original height constraint of 50
            self.heightConstraint.constant = 50
            
            // Redraws the view
            self.view.layoutIfNeeded()
            
        }
        
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    

    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        // This creates a reference to a database inside our main database, called "Messages"
        // If one has not been created with this name, this creates one.
        let messagesDB = Database.database().reference().child("Messages")
        
        // Creating new dictionary that contains the information of the "Sender" and "MessageBody"
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        // This creates a unique key using "childByAutoId()" to save the "messageDictionary" by using the "setValue()" function.
        // This can also end in a closure with an error and a reference.
        
        messagesDB.childByAutoId().setValue(messageDictionary) { (error, reference) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                print("Message saved successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = nil
                
            }
            
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        // Creates a reference to the "Messages" database to use for our message retrieval.
         let messageDB = Database.database().reference().child("Messages")
        
        // Firebase is "observing" for when a "child" is "Added" (a message), and has a closure with it that gets called everytime a new item ("child") is added to the "Messages" database.
        
        // ***** This is how it updates the table view that we set up on another user's screen when they are not actively updating or sending messages:
        // *** When a user sends a message, this method gets called on the sender's device, and updates their own screen, as you'd expect.
        // *** But also what happens is the "messageDB.observe()" function gets called on Firebase, so this message gets run for this device, as well as other devices which are running this app.
        // *** The "print(text)" gets printed when both computer and external device send a message, so this is the function that gets executed at the Firebase level, not just the individual device level.
        // *** Therefore, whether the computer or the external device trigger this "retrieveMessages()" function, the "messageDB.observe(.childAdded) { (snapshot) in" function gets triggered, which runs on the Firebase side, and performs the stuff within the closure as the callback function, triggering all device involved to update their tableview and load the messages, without having to click something on their particular device.
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            // The 'snapshot' value is type "Any?", so we have to cast it to something we can use.
            // Since we were the ones who set the type above, we know it's a Dictionary type of [String: String], so that's what we cast it as, and set it to the constant "snapshotValue".
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            print(text)
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        }
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        // Error handling to catch an error. It tries something first in the "do-catch" block, and throws an error if the "try" fails.
        do {
            try Auth.auth().signOut()
            
            // In a "Navigation Controller" embedding, using this function takes you directly to the root view controller
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error, there was a problem signing out.")
        }
        
        
    }
    


}
