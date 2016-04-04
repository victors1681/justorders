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
        var localPassword: String = ""
    }
    
    
    func setUserInfo(user: String, password: String, token: String, localPassword:String ) {
        
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
            newInformation.setValue(localPassword, forKey: "localPassword")
        
        try context.save()
            print("Save!")
        }catch let error as NSError {
            print("Something happend code: %@", error.code)
        }
     
    }
    
    
    func updateToken(token: String) -> Bool {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        
        request.predicate = NSPredicate(format: "username != %@", "Administrator")
        
        do{
            let results:NSArray = try context.executeFetchRequest(request)
            
            if(results.count > 0){
                //Login Successful
                let result = results[0] as! NSManagedObject
                result.setValue("token", forKey: "token")
                
                
            }
        }catch{
            print("Something wrong!")
        }
        
        return false
        
    }
    
    
    func geUserInfo() -> UserInformation {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        
        request.predicate = NSPredicate(format: "username != %@", "Administrator")
        
        var userInformation : UserInformation = UserInformation.init(username: "", password: "", token: "", name: "", localPassword: "")
        
        do{
            let results:NSArray = try context.executeFetchRequest(request)
            
            if(results.count > 0){
                let result = results[0] as! NSManagedObject
            
                let username = result.valueForKey("username") as? String ?? ""
                let password = result.valueForKey("password") as? String ?? ""
                let token = result.valueForKey("token") as? String ?? ""
                let name = result.valueForKey("name") as? String ?? ""
                let localPassword = result.valueForKey("localPassword") as? String ?? ""
                
                userInformation = UserInformation.init(username: username, password: password, token: token, name: name, localPassword: localPassword)
            }
        }catch{
            print("Something wrong!")
        }
        
        return userInformation
        
    }
    
    
    
    //Default Administrator User
    func setAdministratorUser() {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        
        request.predicate = NSPredicate(format: "username == %@", "Administrator")
        
        do{
            let results:NSArray = try context.executeFetchRequest(request)
            
            if(results.count == 0){
                
                
                let fetchRequest = NSFetchRequest(entityName: "User")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                try context.executeRequest(deleteRequest)
                
                let newInformation = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
                
                newInformation.setValue("Administrator", forKey: "username")
                newInformation.setValue("1681", forKey: "password")
                newInformation.setValue("", forKey: "token")
                newInformation.setValue("1681", forKey: "localPassword")
                
                try context.save()
                
            }
        }catch{
            print("Something wrong!")
        }
        
        
    }
    
    
    func validateLogin(password: String) -> Bool {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        
        request.predicate = NSPredicate(format: "localPassword == %@", password)
        
        do{
            let results:NSArray = try context.executeFetchRequest(request)
            
            if(results.count > 0){
                //Login Successful
                return true
            }
        }catch{
            print("Something wrong!: \(error)")
        }
        
        return false
        
    }

    
}