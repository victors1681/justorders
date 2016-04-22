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
    var localUser: String
    var terminal: String
    var serverUrl: String
    var serverPort: String
    
    
}

struct CompanyData {
    var name: String
    var phone: String
    var address: String
    var city: String
    var region: String
    var taxId: String
    var email: String
    var web: String
}

struct Configurations {
    var discount: Bool
    var changePrice: Bool
}



class UserDefaultModel {
    
    internal let userDefault = NSUserDefaults.standardUserDefaults()
    
    //MARK: Server and user
    func addDataUser(user: UserData) {
        
        let username = user.username
        let password = user.password
        let localPassword = user.localPassword
        let token = user.token
        let localUser = user.localUser
        let terminal = user.terminal
        let serverUrl = user.serverUrl
        let serverPort = user.serverPort
        
        
        if !username.isEmpty { userDefault.setValue(username, forKey: "username") }
        if !password.isEmpty { userDefault.setValue(password, forKey: "password") }
        if !localPassword.isEmpty { userDefault.setValue(localPassword, forKey: "localPassword") }
        if !token.isEmpty { userDefault.setValue(token, forKey: "token") }
        if !localUser.isEmpty { userDefault.setValue(localUser, forKey: "localUser") }
        if !terminal.isEmpty { userDefault.setValue(terminal, forKey: "terminal") }
        if !serverUrl.isEmpty { userDefault.setValue(serverUrl, forKey: "serverUrl") }
        if !serverPort.isEmpty { userDefault.setValue(serverPort, forKey: "serverPort") }
        
        userDefault.synchronize()
        
    }
    
   
    func getDataUser() -> UserData {
        
        
            let username = userDefault.stringForKey("username") ?? ""
            let password = userDefault.stringForKey("password") ?? ""
            let localPassword = userDefault.stringForKey("localPassword") ?? ""
            let token = userDefault.stringForKey("token") ?? ""
            let localUser = userDefault.stringForKey("localUser") ?? ""
            let terminal = userDefault.stringForKey("terminal") ?? ""
            let serverUrl = userDefault.stringForKey("serverUrl") ?? ""
            let serverPort = userDefault.stringForKey("serverPort") ?? ""
            
            let data = UserData(username: username, password: password, localPassword: localPassword, token: token, localUser: localUser, terminal: terminal, serverUrl: serverUrl, serverPort: serverPort)
            
            return data
        
    }
    
    func  getAdministratorPassword() -> String? {
        
        if let obj = userDefault.objectForKey("administratorPassword") as? String {
            return obj
        }
        return nil
    }
    
    func getServerPath() -> String {
        
        let data = getDataUser()
        let serverUrl = data.serverUrl
        let serverPort = data.serverPort
        
        return ("\(serverUrl):\(serverPort)")
        
    }
    
    
    func setAdministratorPassword(password: String)  {
        
        //Set Administrator Local Password
        
        userDefault.setObject(password, forKey: "administratorPassword")
          
        userDefault.synchronize()
    }
    
    func setAdministratorPasswordFisrtTime()  {
        
        //Set Administrator Local Password
        
        if ((userDefault.objectForKey("administratorPassword") as? String) == nil){
           
            userDefault.setObject("1681", forKey: "administratorPassword")
            userDefault.synchronize()
        }
        
    }
    
    
    func validateLogin(password: String)-> Bool {
        
        
        let userdata = getDataUser()
        let adminPass = getAdministratorPassword()
        
        if userdata.localPassword == password || password == adminPass  {
            //Register password login
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(password, forKey: "lastPasswordLogin")
            userDefault.synchronize()
            return true
        }
        
        return false
    }
    
    func getLastPasswordLogin()->String {
        
        guard let lastPwdLogin:String = userDefault.stringForKey("lastPasswordLogin") else {
            return ""
        }
        
        return lastPwdLogin
    }
    
    
    
    //MARK: Company
    
    func setCompany(company: CompanyData){
        
        let name = company.name
        let phone = company.phone
        let address = company.address
        let city = company.city
        let region = company.region
        let taxId = company.taxId
        let email = company.email
        let web = company.web
        
        
        if !name.isEmpty { userDefault.setValue(name, forKey: "companyName") }
        if !phone.isEmpty { userDefault.setValue(phone, forKey: "companyPhone") }
        if !address.isEmpty { userDefault.setValue(address, forKey: "companyAddress") }
        if !city.isEmpty { userDefault.setValue(city, forKey: "companyCity") }
        if !region.isEmpty { userDefault.setValue(region, forKey: "companyRegion") }
        if !taxId.isEmpty { userDefault.setValue(taxId, forKey: "companyTaxId") }
        if !email.isEmpty { userDefault.setValue(email, forKey: "companyEmail") }
        if !web.isEmpty { userDefault.setValue(web, forKey: "companyWeb") }
        
        userDefault.synchronize()
    }
    
    
    func getCompany()-> CompanyData {
        
        
        
        let name = userDefault.stringForKey("companyName")  ?? ""
        let phone = userDefault.stringForKey("companyPhone")  ?? ""
        let address = userDefault.stringForKey("companyAddress")  ?? ""
        let city = userDefault.stringForKey("companyCity") ?? ""
        let region = userDefault.stringForKey("companyRegion") ?? ""
        let taxId = userDefault.stringForKey("companyTaxId") ?? ""
        let email = userDefault.stringForKey("companyEmail") ?? ""
        let web = userDefault.stringForKey("companyWeb") ?? ""
        
        return CompanyData(name: name, phone: phone, address: address, city: city, region: region, taxId: taxId, email: email, web: web)
        
    }
    
    
    
    //MARK: Configurations
    
    func setConfiguration(config: Configurations) {
        
        let discount = config.discount
        let changePrice = config.changePrice
        
        
         userDefault.setBool(discount, forKey: "discount")
         userDefault.setBool(changePrice, forKey: "changePrice")
        
        userDefault.synchronize()
    }
    
    func getConfiguration() -> Configurations{
        
        
        let discount = userDefault.boolForKey("discount")
        let changePrice = userDefault.boolForKey("changePrice")
     
        return Configurations(discount: discount, changePrice: changePrice)
    }
    
    
    //MARK: Secuences Order and Client
    
    func increaseOrderSec() {
        guard let sec:String = userDefault.valueForKey("orderSec") as? String else {
            //Setting initial Value
            userDefault.setValue("1", forKey: "orderSec")
            userDefault.synchronize()
            print("Setting new order number")
            return
        }
        
        if Int(sec) != nil {
            let newSec = Int(sec)! + 1
            
            userDefault.setValue(String(newSec), forKey: "orderSec") //New Secuence stored
            userDefault.synchronize()
        }else{
            print("Error to set Order Secuences")
        }
    }
    
    func setOrderSec(sec: String) {
        
        // Sec is String whether someday we need a alphanumeric secuences
        guard let intSec = Int(sec) else{
            print("Error to set Secuences")
            return
        }
        
        userDefault.setValue(String(intSec), forKey: "orderSec") //New Secuence stored
        userDefault.synchronize()
    }
    
    func getOrderSec()->String {
        
        guard let sec:String = userDefault.valueForKey("orderSec") as? String else {
            //Setting initial Value
            userDefault.setValue("1", forKey: "orderSec")
            userDefault.synchronize()
             print("Setting new order number")
            return "1" //initial secuence
        }
        
        return sec
    }
    
    func increaseClienSec() {
        guard let sec:String = userDefault.valueForKey("clientSec") as? String else {
         return
        }

        let part = sec.componentsSeparatedByString("-") //part[0] terminal number, part[2] client secuence
        
        guard let newSec:Int = (Int(part[1])! + 1) else{
            print("Error to set Client Secuences")
            return
        }
        
        let terminal = userDefault.valueForKey("terminal") as? String ?? "0"
        let newClientSec = "\(terminal)-\(newSec)"
        
        userDefault.setValue(newClientSec, forKey: "clientSec") //New Secuence stored
        userDefault.synchronize()

    }
    
    
    func setClientSec(sec: String) {
        
        // Sec is String whether someday we need a alphanumeric secuences
        let part = sec.componentsSeparatedByString("-") //part[0] terminal number, part[2] client secuence
        var newSec:Int = 0
        
        if  part.count == 2 { //has tow part terminal number and Secuences
            if Int(part[1]) != nil  {
                newSec = (Int(part[1])! + 1)
            }else{
                newSec = 0
            }
            
            
        }else{ //increase sec and concat terminal number
            if Int(sec) != nil {
                newSec = Int(sec)! + 1
            }else{
                newSec = 0
            }
        }
        
        let terminal = userDefault.valueForKey("terminal") as? String ?? "0"
        let newClientSec = "\(terminal)-\(newSec)"
        
        userDefault.setValue(newClientSec, forKey: "clientSec") //New Secuence stored
        userDefault.synchronize()
    }
    
    func getClientSec()->String {
        
        //Client ID is conformed by terminal number + Client Sec
        
        guard let sec:String = userDefault.valueForKey("clientSec") as? String else {
            //Setting initial Value
            let terminal:String = userDefault.valueForKey("terminal") as? String ??  "0"
            
            let newSec = "\(terminal)-1"
            
            userDefault.setValue(newSec, forKey: "clientSec")
            userDefault.synchronize()
            print("Setting new client sec number")
            return newSec //initial secuence
        }
         
        return sec
    }
    
    
    
}










