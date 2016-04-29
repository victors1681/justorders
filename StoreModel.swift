//
//  ClientModel.swift
//  JustOrders
//
//  Created by Victor Santos on 4/10/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite

struct Stores {
    
    var storeId:Int
    var name: String
    var phone: String
}

class StoreModel {
    
    func convertJson(dataIn:JSON)-> [Stores] {
        
        var stores: [Stores] = []
        
        for data in dataIn.arrayValue {
            
            
            let storeId: Int = data["storeId"].intValue ?? 0
            let name: String = data["name"].stringValue ?? ""
            let phone: String = data["phone"].stringValue ?? ""
            
            let storeItem =  Stores(storeId: storeId, name: name, phone: phone)
            
            stores.append(storeItem)
        }
        
        return stores
    }
    
    func insertStore(stores:[Stores]) -> Int {
        
        //Clean DB
        DBModel()!.cleanStoreDB()
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        var qty = 0;
        
        if((db) != nil){
            
            for store in stores {
                
                let storeId = store.storeId
                let name  = store.name
                let phone =  store.phone
                
                
                do{
                    
                    try db!.run("INSERT INTO Stores (storeId, name, phone ) VALUES (?,?,?) ", storeId, name, phone )
                    
                    qty += 1
                    
                }catch{
                    print("error insert Store : \(error)")
                    return 0
                }
            }
        }
        
        return qty
    }
    
    
    
    func getStore(storeIdIn: Int)-> [Stores] {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        var storesArr: [Stores] = []
        
        if((db) != nil){
            
            let stores = Table("Stores")
            
            let storeId = Expression<Int>("storeId")
            let name  = Expression<String>("name")
            let phone = Expression<String>("phone")
            
            do{
                
                var query: Table
                
                if storeIdIn > 0 {
                    query = stores.select(storeId, name, phone)
                    .filter(storeId == storeIdIn)
                }else{
                    query = stores.select(storeId, name, phone)
                }
                
                for row in try db!.prepare(query) {
                    
                    let store = Stores(storeId: row[storeId], name: row[name], phone: row[phone])
                    
                    storesArr.append(store)
                    
                }
            }catch{
                print("Error to load stores \(error)")
            }
            
        }
        
        if storesArr.count > 0 {
            return storesArr
        }
        
        return storesArr
        
    }
}







