//
//  DBModel.swift
//  JustOrders
//
//  Created by Victor Santos on 3/28/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite




class DBModel {

    var db: Connection
    var path: String = ""
    
    init?()  {
        
        do{
            
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileURL = documentsURL.URLByAppendingPathComponent("MBS.sqlite")
            
            self.db = try Connection(fileURL.path!)
           
            createInventoryDB()
           
            createOrdersDB()
            createOrderDetailDB()
            createClientDB()
            
        }catch{
           print("Error to connect to DB: \(error)")
            return nil
        }
    }
    
    
    //Importan for execute querys
    func getDB() -> Connection {
        return self.db
    }
    
  //MARK: Inventory Table
    
    func createInventoryDB(){
        
        let inventory = Table("inventory")
        
        let numReg = Expression<Int64>("id")
        let code = Expression<String>("code")
        let barCode  = Expression<String>("barCode")
        let description  = Expression<String>("description")
        let und  = Expression<String>("und")
        let packing  = Expression<String>("packing")
        let shortDescription  = Expression<String>("shortDescription")
        let productType  = Expression<String>("productType")
        let line  = Expression<String>("line")
        let tax = Expression<Double>("tax")
        
        let stock = Expression<Double>("stock")
        let cost = Expression<Double>("cost")
        let costAverage = Expression<Double>("costAverage")
        
        let observation = Expression<String>("observation")
        
        let price1 = Expression<Double>("price1")
        let price2 = Expression<Double>("price2")
        let price3 = Expression<Double>("price3")
        let price4 = Expression<Double>("price4")
        let price5 = Expression<Double>("price5")
        
      
        let camp1 = Expression<String>("camp1")
        let camp2 = Expression<String>("camp2")
        let camp3 = Expression<String>("camp3")
        let campNum1 = Expression<Double>("campNum1")
        let campNum2 = Expression<Double>("campNum2")
        let campNum3 = Expression<Double>("campNum3")
        
        let image = Expression<String>("image")
        let largeImage = Expression<String>("largeImage")
        let thumbnail = Expression<String>("thumbnail")
        
        let wh1 = Expression<Double>("wh1")
        let wh2 = Expression<Double>("wh2")
        let wh3 = Expression<Double>("wh3")
        let wh4 = Expression<Double>("wh4")
        let wh5 = Expression<Double>("wh5")
        let wh6 = Expression<Double>("wh6")
        let wh7 = Expression<Double>("wh7")
     
        
        do{
        
            try self.db.run(inventory.create(ifNotExists: true) { t in
                t.column(numReg, primaryKey: true)
                t.column(code, unique: true)
                t.column(barCode)
                t.column(description)
                t.column(und)
                t.column(packing)
                t.column(shortDescription)
                t.column(productType)
                t.column(line)
                t.column(tax)
                t.column(stock)
                t.column(cost)
                t.column(costAverage)
                t.column(observation)
                t.column(price1)
                t.column(price2)
                t.column(price3)
                t.column(price4)
                t.column(price5)
                t.column(camp1)
                t.column(camp2)
                t.column(camp3)
                t.column(campNum1)
                t.column(campNum2)
                t.column(campNum3)
                t.column(image)
                t.column(largeImage)
                t.column(thumbnail)
                t.column(wh1)
                t.column(wh2)
                t.column(wh3)
                t.column(wh4)
                t.column(wh5)
                t.column(wh6)
                t.column(wh7)
                
            })
            
        }catch {
            print("creation failed: \(error)")
        }
    }
    
    
    
  //MARK: Orders Table
    
    func createOrdersDB(){
        
        let orders = Table("orders")
        
      /*  do{
            try db.run(orders.drop())
        }catch{
            
        }
        */
        
        let numReg = Expression<Int64>("numReg")
        let orderId = Expression<Int64>("orderId")
        let clientId = Expression<String>("clientId")
        let newClient = Expression<Bool>("newClient")
        let terminalNo  = Expression<Int64>("terminalNo")
        let totalOrder = Expression<Double>("totalOrder")
        let totalTax = Expression<Double>("totalTax")
        let subTotal = Expression<Double>("subTotal")
        let amountPaid = Expression<Double>("amountPaid")
        let amountChange = Expression<Double>("amountChange")
        let paymentMethod  = Expression<String>("paymentMethod")
        let totalDiscount = Expression<Double>("totalDiscount")
        let discountPercent = Expression<Double>("discountPercent")
        let documentType  = Expression<String>("documentType")
        let ncf  = Expression<String>("ncf")
        let orderNote  = Expression<String>("orderNote")
        let userName  = Expression<String>("userName")
        let date  = Expression<String>("date")
        let sendTo  = Expression<String>("sendTo")
        let sync  = Expression<Bool>("sync")
        let syncDate  = Expression<String>("syncDate")
        
        do{
            
            try self.db.run(orders.create(ifNotExists: true) { t in
                t.column(numReg, primaryKey:.Autoincrement)
                t.column(orderId, unique: true)
                t.column(clientId)
                t.column(newClient, defaultValue: false)
                t.column(terminalNo)
                t.column(totalOrder)
                t.column(totalTax)
                t.column(subTotal)
                t.column(amountPaid)
                t.column(amountChange)
                t.column(paymentMethod)
                t.column(totalDiscount)
                t.column(discountPercent)
                t.column(documentType)
                t.column(ncf)
                t.column(orderNote)
                t.column(userName)
                t.column(date)
                t.column(sendTo)
                t.column(sync, defaultValue: false)
                t.column(syncDate, defaultValue: "")
                
                })
            
        }catch {
            print("creation failed: \(error)")
        }
    }

    
    func createOrderDetailDB(){
        
        let orderDetail = Table("orderDetail")
        
      /*  do{
            try db.run(orderDetail.drop())
        }catch{
            
        }
        */
        let numReg = Expression<Int64>("numReg")
        let orderId = Expression<Int64>("orderId")
        let terminalNo  = Expression<Int64>("terminalNo")
        
        let code = Expression<String>("code")
        let description = Expression<String>("description")
        let unit = Expression<String>("unit")
        let amountTax = Expression<Double>("amoudeptTax")
        let quantity = Expression<Double>("quantity")
        let price  = Expression<Double>("price")
        let discount1 = Expression<Double>("discount1")
        let discount2 = Expression<Double>("discountPercent")
        
        
        do{
            
            try self.db.run(orderDetail.create(ifNotExists: true) { t in
                t.column(numReg, primaryKey:.Autoincrement)
                t.column(orderId)
                t.column(terminalNo)
                t.column(code)
                t.column(description)
                t.column(unit)
                t.column(amountTax)
                t.column(quantity)
                t.column(price)
                t.column(discount1, defaultValue:0.0)
                t.column(discount2, defaultValue:0.0)
                
                })
            
        }catch {
            print("creation failed: \(error)")
        }
    }
    
    
    //MARK: Client Table
    
    func createClientDB(){
        
        let client = Table("clients")
        
      /*  do{
            try db.run(client.drop())
        }catch{
            
        }
        */
        
        let numReg = Expression<Int64>("numReg")
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
            
            try self.db.run(client.create(ifNotExists: true) { t in
                t.column(numReg, primaryKey:.Autoincrement)
                t.column(clientId, unique: true)
                t.column(name)
                t.column(email)
                t.column(address)
                t.column(phone)
                t.column(cellPhone)
                t.column(taxId)
                t.column(city)
                t.column(clasification)
                t.column(taxeable, defaultValue:false)
                
                })
            
        }catch {
            print("creation failed: \(error)")
        }
    }
    
    
}