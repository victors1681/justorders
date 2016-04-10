//
//  ClientModel.swift
//  JustOrders
//
//  Created by Victor Santos on 4/10/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite

class ClientModel {
    
    func insertClient(client:ClientSelection) -> Bool {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        
        if((db) != nil){
            
            
            let userDef = UserDefaultModel()
            
            let clientId = client.code // TerminalNo '-' Sec.No
            let name  = client.name
            let email =  client.email
            let address = client.address
            let phone = client.phone
            let cellPhone = client.cellPhone
            let taxId = client.taxId
            let city  = client.city
            let clasification = client.clasification
            let taxeable = client.taxeable
            
            do{
                
                try db!.run("INSERT INTO Clients (clientId, name, email, address, phone, cellphone, taxId, city, clasification, taxeable) VALUES (?,?,?,?,?,?,?,?,?,?) ", clientId, name, email, address, phone, cellPhone, taxId, city, clasification, taxeable)
                
                //Increase Order number
                userDef.setClientSec(clientId)
                
            }catch{
                print("error insert Order : \(error)")
                return false
            }
            
        }
        
        return true
    }
}