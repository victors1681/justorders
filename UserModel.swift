//
//  UserModel.swift
//  JustOrders
//
//  Created by Victor Santos on 3/16/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import CoreData
import UIKit

class UserModel {
    
    
    struct UserInformation {
        
        var username : String = ""
        var password : String = ""
        var token : String = ""
        var name: String = ""
    }
    
    
    func setUserInfo(user: String, password: String, token: String ) {
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
        do{
        
            let fetchRequest = NSFetchRequest(entityName: "User")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try context.executeRequest(deleteRequest)
            
            let newInformation = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
            
            newInformation.setValue(user, forKey: "username")
            newInformation.setValue(password, forKey: "password")
            newInformation.setValue(token, forKey: "token")
        
        try context.save()
            print("Save!")
        }catch let error as NSError {
            print("Something happend code: %@", error.code)
        }
     
    }
    
    
    func geUserInfo() -> UserInformation {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        var userInformation : UserInformation = UserInformation.init(username: "", password: "", token: "", name: "")
        
        do{
            let results:NSArray = try context.executeFetchRequest(request)
            
            if(results.count > 0){
                let result = results[0] as! NSManagedObject
            
                let username = result.valueForKey("username") as? String ?? ""
                let password = result.valueForKey("password") as? String ?? ""
                let token = result.valueForKey("token") as? String ?? ""
                let name = result.valueForKey("name") as? String ?? ""
            
                userInformation = UserInformation.init(username: username, password: password, token: token, name: name)
            }
        }catch{
            print("Something wrong!")
        }
        
        return userInformation
        
    }

    
}