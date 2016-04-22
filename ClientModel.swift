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
                userDef.increaseClienSec()
                
            }catch{
                print("error insert Order : \(error)")
                return false
            }
            
        }
        
        return true
    }
    
    
    
     func getClient(clientIdIn: String)-> ClientSelection {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        var clientsArr: [ClientSelection] = []
        
        if((db) != nil){
            
            let clients = Table("clients")
            
            //let numReg = Expression<Int64>("numReg")
            let clientId = Expression<String>("clientId") // TerminalNo '-' Sec.No
            let name  = Expression<String>("name")
            let email = Expression<String>("email")
            let address = Expression<String>("address")
            let phone = Expression<String>("phone")
            let cellPhone = Expression<String>("cellPhone")
            let taxId = Expression<String>("taxId")
            let city  = Expression<String>("city")
            let clasification = Expression<String>("clasification")
            let taxeable = Expression<Bool>("taxeable")
            
            do{
                
                let query = clients.select(clientId, name, email, address, phone, cellPhone, taxId, city, clasification, taxeable)
                    .filter(clientId == clientIdIn)
                
                for row in try db!.prepare(query) {
                    
                    let client = ClientSelection(code: row[clientId], name: row[name], email: row[email], address: row[address], phone: row[phone], cellPhone: row[cellPhone], taxId: row[taxId], city: row[city], clasification: row[clasification], taxeable: row[taxeable], newClient: false)
                    
                    clientsArr.append(client)
                    
                }
            }catch{
                print("Error to load inventory \(error)")
            }
            
        }
        
        if clientsArr.count > 0 {
            return clientsArr[0]
        }
        
        return ClientSelection(code: "", name: "", email: "", address: "", phone: "", cellPhone: "", taxId: "", city: "", clasification: "", taxeable: false, newClient: false)
        
    }
}







