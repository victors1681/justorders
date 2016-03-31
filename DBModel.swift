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
        
            
            //Create Table Default
           /* do{
                let inventory = Table("inventory")
                try db.run(inventory.drop())
            }catch{
                
            }*/
            createInventoryDB()
            
        }catch{
           print("Error to connect to DB: \(error)")
            return nil
        }
    }
    
    
    //Importan for execute querys
    func getDB() -> Connection {
        return self.db
    }
    
   
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
    
}