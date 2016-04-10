//
//  OrderModel.swift
//  JustOrders
//
//  Created by Victor Santos on 4/10/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite


class OrderModel {
    
    
    func insertOrder(order:PointSale) -> Bool {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        
        if((db) != nil){
            
            
            let userDef = UserDefaultModel()
            
            let orderSec:String = userDef.getOrderSec()
            let clientId: String = order.client.code
            let newClient: Bool = order.client.newClient
            let terminalNo: Int = Int(userDef.getDataUser().terminal) ?? 0
            let totalOrder: Double = order.totalOrder
            let totalTax: Double = order.totalTax
            let subTotal:Double = order.subTotal
            let amountPaid:Double = order.amountPaid
            let amountChange:Double = order.amountChange
            let paymentMethod :String = order.paymentMethod.rawValue
            let totalDiscount:Double = order.totalDiscount
            let discountPercent:Double = order.discountPercent
            let documentType:String = order.documentType.rawValue
            let ncf:String = order.ncf
            let orderNote:String = order.orderNote
            let userName:String = userDef.getDataUser().localUser ?? ""
          
             do{
                    
                    try db!.run("INSERT INTO Orders (orderId, clientId, newClient, terminalNo, totalOrder, totalTax, subTotal, amountPaid, amountChage, paymentMethod, totalDiscount, discountPercent, documentType, ncf, orderNote, username, date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, SELECT date('now')) ", orderSec, clientId, newClient, terminalNo, totalOrder, totalTax, subTotal, amountPaid, amountChange, paymentMethod, totalDiscount, discountPercent, documentType, ncf, orderNote, userName )
                
                //Insert Detailts
                insertOrderDetail(order.selection, orderId: orderSec)
                //Increase Order number
                userDef.setOrderSec(orderSec)
                
                //Whether is a new client insert
                if order.client.newClient {
                    ClientModel().insertClient(order.client)
                }
                    
                }catch{
                    print("error insert Order : \(error)")
                    return false
                }
            
        }
        
        return true
    }
    
    
    func insertOrderDetail(orderDetails:[InventorySelectionItem], orderId: String) ->Int  {
        
        let userDef = UserDefaultModel()
        let terminalNo  = userDef.getDataUser().terminal
      
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        var detailQty = 0;
        
        if((db) != nil){
            
            
            for row in orderDetails {
                do{
                    
                    try db!.run("INSERT INTO orderDetail (orderId, terminalNo, code, description, unit, amountTax, quantity, price, discount1, discount2) VALUES (?,?,?,?,?,?,?,?,?,?)", orderId, terminalNo, row.code, row.description, row.unit, row.amountTax, row.quantity, row.price, row.discount1, row.discountPercent )
                    
                    detailQty += 1
                    
                }catch{
                    print("error insert Order details : \(error)")
                    return 0
                }
            }
        }
        
        return detailQty
        
    }
    
    
}







