//
//  AppDelegate.swift
//  Flash Chat
//
//  The App Delegate listens for events from the system. 
//  It recieves application level messages like did the app finish launching or did it terminate etc. 
//

import UIKit

// Had to import Firebase first
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // ********** This is the first method that gets triggered when any app is first opened.
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: Initialise and Configure your Firebase here:
        
        // **********
        // ********** This allows Firebase to configure before anything else in the app gets run.
        // **********
        
        FirebaseApp.configure()
        
        
        
        // Reference to brand new database for Firebase
        
        // This following line is commented out because of the following information at the astericks
        // let myDatabase = Database.database().reference()
        
        // Sample saved value in the database
        // In order for this to save, the "RealTime Database" rules had to be set to "true" for "read" and "write".
        // Authentication will come later, but for now, that's what happened for our sample.
        
        
        // ******** BUG: If this gets executed, it wipes the entire database upon loading, and replaces it with this one value. In testing, it's fine to do this one thing. In practice, you don't want to wipe your whole database each time you initialize the app, as this clears EVERYTHING. So, when we aren't using it, we will comment out this following line:
        
        // ********* Comment out the following line, or the whole database gets wiped!:
        // myDatabase.setValue("We've got data!")
        
        return true
    }

    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//MARK: - Uncomment this only once you've gotten to Step 14.
    
     
//    let api = API()
//    
//    let APP_ID = api.appID
//    let CLIENT_KEY = api.clientKey
    



}

