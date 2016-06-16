//
//  InventoryModel.swift
//  JustOrders
//
//  Created by Victor Santos on 3/28/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import SQLite

protocol ProductItemType{
    
    var code: String { get }
    var barCode: String { get }
    var description: String { get }
    var und: String { get }
    var packing: String { get }
    var shortDescription: String { get }
    var productType: String { get }
    var line: String { get }
    var tax: Double { get }
    var stock: Double { get }
    var cost: Double { get }
    var costAverage:Double { get }
    var observation:String { get }
    var prices : Prices { get }
    var freeCamp: FreeCamp { get }
    var media: Media { get }
    var werehouse : Werehouse { get }
}

protocol PricesType
{
    var price1:Double { get }
    var price2:Double { get }
    var price3:Double { get }
    var price4:Double { get }
    var price5:Double { get }
    
}

protocol FreeCampType
{
    
    var camp1:String { get }
    var camp2:String { get }
    var camp3:String { get }
    
    var campNum1:Double { get }
    var campNum2:Double { get }
    var campNum3:Double { get }
}

protocol MediaType
{
    var image: String { get }
    var largeImage: String { get }
    var thumbnail: String { get }
}

protocol WerehouseType
{
    
    var wh1:Double { get }
    var wh2:Double { get }
    var wh3:Double { get }
    var wh4:Double { get }
    var wh5:Double { get }
    var wh6:Double { get }
    var wh7:Double { get }
    
}


struct ProductItems: ProductItemType {
    
    var code: String
    var barCode: String
    var description: String
    var und: String
    var packing: String
    var shortDescription: String
    var productType: String
    var line: String
    var tax: Double
    var stock: Double
    var cost: Double
    var costAverage:Double
    var observation:String
    var prices : Prices
    var freeCamp: FreeCamp
    var media: Media
    var werehouse :Werehouse
}


struct Prices:PricesType {
    var price1:Double
    var price2:Double
    var price3:Double
    var price4:Double
    var price5:Double
    
}


struct FreeCamp:FreeCampType
{
    
    var camp1:String
    var camp2:String
    var camp3:String
    
    var campNum1:Double
    var campNum2:Double
    var campNum3:Double
}

struct Media: MediaType
{
    var image: String
    var largeImage: String
    var thumbnail: String
}

struct Werehouse:WerehouseType
{
    
    var wh1:Double
    var wh2:Double
    var wh3:Double
    var wh4:Double
    var wh5:Double
    var wh6:Double
    var wh7:Double
    
}


class InventoryModel {
    
    func convertJson(dataIn:JSON)-> [ProductItems] {
        
        var inventory: [ProductItems] = []
        
        for data in dataIn.arrayValue {
            
        
        let code: String = data["code"].stringValue ?? ""
        let barCode: String = data["barCode"].stringValue ?? ""
        let description: String = data["description"].stringValue ?? ""
        let und: String = data["und"].stringValue ?? ""
        let packing: String = data["packing"].stringValue ?? ""
        let shortDescription: String = data["shortDescription"].stringValue ?? ""
        let productType: String = data["productType"].stringValue ?? ""
        let line: String = data["line"].stringValue ?? ""
        let tax: Double = data["tax"].doubleValue ?? 0
        let stock: Double = data["stock"].doubleValue ?? 0
        let cost: Double = data["cost"].doubleValue ?? 0
        let costAverage:Double = data["costAverage"].doubleValue ?? 0
        let observation:String = data["observation"].stringValue ?? ""
        let prices :Prices = convertPrices(data["prices"])
        let freeCamp: FreeCamp = convertFreeCamp(data["freeCamp"])
        let media: Media = convertMedia(data["media"])
        let werehouse : Werehouse = convertWerehouse(data["wherehouse"])
        
        
        
        let productItem =  ProductItems(code: code, barCode: barCode, description: description, und: und, packing: packing, shortDescription: shortDescription, productType: productType, line: line, tax: tax, stock: stock, cost: cost, costAverage: costAverage, observation: observation, prices: prices, freeCamp: freeCamp, media: media, werehouse: werehouse)
            
            inventory.append(productItem)
        }
        
        return inventory
    }
    
    
    
    
    func insertProducts(products:[ProductItems]) -> Int {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        
        
        var productQty = 0;
        
        if((db) != nil){
            
            //Clean Table before insert
            let inventoryDB = Table("inventory")
           
            do{
              try db!.run(inventoryDB.delete())
            }catch{
                print("Error to clean inventory: \(error)")
            }
        
            for product in products {
                do{
                    
                try db!.run("INSERT INTO inventory (code,barCode,description,und,packing,shortDescription,productType,line,tax,stock,cost,costAverage,observation,price1,price2,price3,price4,price5,camp1,camp2,camp3,campNum1,campNum2, campNum3, image, largeImage, thumbnail,wh1, wh2, wh3, wh4, wh5, wh6, wh7) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", product.code, product.barCode, product.description, product.und, product.packing, product.shortDescription, product.productType, product.line, String(product.tax), String(product.stock), String(product.cost), String(product.costAverage), product.observation, String(product.prices.price1), String(product.prices.price2), String(product.prices.price3), String(product.prices.price4), String(product.prices.price5), product.freeCamp.camp1, product.freeCamp.camp2, product.freeCamp.camp3, String(product.freeCamp.campNum1), String(product.freeCamp.campNum2), String(product.freeCamp.campNum3), product.media.image, product.media.largeImage, product.media.thumbnail, String(product.werehouse.wh1), String(product.werehouse.wh2), String(product.werehouse.wh3), String(product.werehouse.wh4), String(product.werehouse.wh5), String(product.werehouse.wh6), String(product.werehouse.wh7))
                    
                    productQty += 1
                    
                }catch{
                    print("error insert Inventory : \(error)")
                }
            }
        }
        
        return productQty
    }
    
    func getInventory() -> [ProductItems] {
        
        let dbModel = DBModel.init()
        let db = dbModel?.getDB()
        var products: [ProductItems] = []
        
        if((db) != nil){
            
            let inventory = Table("inventory")
            
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
          
                for product in try db!.prepare(inventory.order(description)) {
                
                let prices = Prices(price1: product[price1], price2: product[price2], price3: product[price3], price4: product[price4], price5: product[price5])
                let freeCamp = FreeCamp(camp1: product[camp1], camp2: product[camp2], camp3: product[camp3], campNum1: product[campNum1], campNum2: product[campNum2], campNum3: product[campNum3])
                let media = Media(image: product[image], largeImage: product[largeImage], thumbnail: product[thumbnail])
                let werehouse = Werehouse(wh1: product[wh1], wh2: product[wh2], wh3: product[wh3], wh4: product[wh4], wh5: product[wh5], wh6: product[wh6], wh7: product[wh7])
                
                let item = ProductItems(code: product[code], barCode: product[barCode], description: product[description], und: product[und], packing: product[packing], shortDescription: product[shortDescription], productType: product[productType], line: product[line], tax: product[tax], stock: product[stock], cost: product[cost], costAverage: product[costAverage], observation: product[observation], prices: prices, freeCamp: freeCamp, media: media, werehouse: werehouse)
                
                products.append(item)
                
            }
            }catch{
                print("Error to load inventory \(error)")
            }
            
        }
        
        return products
        
    }
    
    
    private func convertPrices(data:JSON)-> Prices {
        
        let price1 = data[0]["price1"].doubleValue ?? 0
        let price2 = data[0]["price2"].doubleValue ?? 0
        let price3 = data[0]["price3"].doubleValue ?? 0
        let price4 = data[0]["price4"].doubleValue ?? 0
        let price5 = data[0]["price5"].doubleValue ?? 0
        
        return Prices(price1: price1, price2: price2, price3: price3, price4: price4, price5: price5)
        
    }
    
    private func convertFreeCamp(data:JSON) -> FreeCamp {
        
        let camp1:String = data[0]["camp1"].stringValue ?? ""
        let camp2:String = data[0]["camp2"].stringValue ?? ""
        let camp3:String = data[0]["camp3"].stringValue ?? ""
        
        let campNum1:Double = data[0]["camp4"].doubleValue ?? 0
        let campNum2:Double = data[0]["camp5"].doubleValue ?? 0
        let campNum3:Double = data[0]["camp6"].doubleValue ?? 0
        
        return FreeCamp(camp1: camp1, camp2: camp2, camp3: camp3, campNum1: campNum1, campNum2: campNum2, campNum3: campNum3)
        
    }
    
    
    private func convertMedia(data:JSON) -> Media {
        
        let image: String = data[0]["image"].stringValue ?? ""
        let largeImage: String = data[0]["largeImage"].stringValue ?? ""
        let thumbnail: String = data[0]["thumbnail"].stringValue ?? ""
        
        
        return Media(image: image, largeImage: largeImage, thumbnail: thumbnail)
        
    }

    private func convertWerehouse(data:JSON) -> Werehouse {
        
        let wh1:Double = data[0]["wh1"].doubleValue ?? 0
        let wh2:Double = data[0]["wh2"].doubleValue ?? 0
        let wh3:Double = data[0]["wh3"].doubleValue ?? 0
        let wh4:Double = data[0]["wh4"].doubleValue ?? 0
        let wh5:Double = data[0]["wh5"].doubleValue ?? 0
        let wh6:Double = data[0]["wh6"].doubleValue ?? 0
        let wh7:Double = data[0]["wh7"].doubleValue ?? 0
        
        return Werehouse(wh1: wh1, wh2: wh2, wh3: wh3, wh4: wh4, wh5: wh5, wh6: wh6, wh7: wh7)
        
    }



}








