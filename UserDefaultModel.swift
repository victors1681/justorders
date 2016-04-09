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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
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
    
    func getServerPath() -> String {
        
        let data = getDataUser()
        let serverUrl = data.serverUrl
        let serverPort = data.serverPort
        
        return ("\(serverUrl):\(serverPort)")
        
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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
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
        
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
         userDefault.setBool(discount, forKey: "discount")
         userDefault.setBool(changePrice, forKey: "changePrice")
        
        userDefault.synchronize()
    }
    
    func getConfiguration() -> Configurations{
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        let discount = userDefault.boolForKey("discount")
        let changePrice = userDefault.boolForKey("changePrice")
     
        return Configurations(discount: discount, changePrice: changePrice)
    }
    
    
}










