//
//  UserDefaultModel.swift
//  JustOrders
//
//  Created by Victor Santos on 3/31/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import Foundation

struct UserData {
    
    var username: String
    var password: String
    var localPassword: String
    var token: String
    var name: String
    
}


class UserDefaultModel {
    
    func addDataUser(user: UserData) {
        
        let username = user.username
        let password = user.password
        let localPassword = user.localPassword
        let token = user.token
        let name = user.name
        
        var dataUserArr = [String: String]()
        
        
        if !username.isEmpty { dataUserArr["username"] = username }
        if !password.isEmpty { dataUserArr["password"] = password }
        if !localPassword.isEmpty { dataUserArr["localPassword"] = localPassword }
        if !token.isEmpty { dataUserArr["token"] = token }
        if !name.isEmpty { dataUserArr["name"] = name }
        
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject(dataUserArr, forKey: "userDefault")
        
        userDefault.synchronize()
        
        
    }
    
    func getDataUser() -> UserData {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let obj = userDefault.objectForKey("userDefault") as? [String: String] {
            
            let username:String = obj["username"] ?? ""
            let password = obj["password"] ?? ""
            let localPassword = obj["localPassword"] ?? ""
            let token = obj["token"] ?? ""
            let name = obj["name"] ?? ""
            
            let data = UserData(username: username, password: password, localPassword: localPassword, token: token, name: name)
            return data
            
        }
        
        return UserData(username: "", password: "", localPassword: "", token: "", name: "")
        
    }
    
    func setAdministratorPassword(password: String)  {
        
        //Set Administrator Local Password
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject("1681", forKey: "administratorPassword")
          
        userDefault.synchronize()
    }
    
    func setAdministratorPasswordFisrtTime()  {
        
        //Set Administrator Local Password
        let userDefault = NSUserDefaults.standardUserDefaults()
        if ((userDefault.objectForKey("administratorPassword") as? String) == nil){
           
            userDefault.setObject("1681", forKey: "administratorPassword")
            userDefault.synchronize()
        }
        
    }
    
    func  getAdministratorPassword() -> String? {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let obj = userDefault.objectForKey("administratorPassword") as? String {
            return obj
        }
        
        return nil
        
    }
    
    func validateLogin(password: String)-> Bool {
        
        
        let userdata = getDataUser()
        let adminPass = getAdministratorPassword()
        
        if userdata.password == password || password == adminPass  {
            return true
        }
        
        return false
    }
    
}
