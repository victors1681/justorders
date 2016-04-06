//
//  ServiceData.swift
//  JustOrders
//
//  Created by Victor Santos on 3/15/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import Foundation
import Alamofire



protocol ServicesDataType {
    var baseUrl : String { get }
    var prefixUrl : String { get }
    
    func getDataClient() throws
    func getDataInventory() throws
    
    //func jsonRequest(resource: String, method: Alamofire.Method, header: [String:String], parameter: String , responseData:(JSON)->())
    
    func getToken(username: String, password: String)
}


private enum ResoursePath {
    
    
    case Inventory(filtro:String)
    case Clients(vendedorID:String, filtro: String)
    case Token
    case Value

    var description: String{
        
        switch self{
        case .Inventory(let filtro)  : return ("api/Productos?FILTRO=\(filtro)")
        case .Clients(let vendedorID, let filtro) : return ("/Clientes?ID_VENDEDOR=\(vendedorID)&FILTRO=\(filtro)")
        case .Token : return ("token")
        case .Value : return ("api/values")
            
        }
        
    }

}


enum ServicesDataError {
 
    case EmptyToken
    case UserFail
}

class ServicesData:ServicesDataType {
    
    internal let baseUrl = "http://192.168.2.236:8087"
   // internal let prefixUrl = "Webservice/WebService.asmx"
    
    
    
    internal var gobalToken = UserDefaultModel().getDataUser().token
    internal let prefixUrl = ""

    
    func getDataClient() throws {
        
      //  let resorurce = ResoursePath.Clients(vendedorID: "75", filtro: "1").description
        
      //  self.jsonRequest(resorurce) { (JSON) -> () in
      //      print(JSON)
      //  }
    }

    func getDataInventory() throws {
        
        if !gobalToken.isEmpty {
            let headers = [
            "Authorization" : "bearer \(gobalToken)"
            ]
            
            let resource = ResoursePath.Inventory(filtro: "1").description
            
            self.jsonRequest(resource, header: headers, responseData: { (JSON) -> () in
               
                //Json Result from request convert to data producto
                let inventory = InventoryModel()
                let data  = inventory.convertJson(JSON["data"])
                
                //Insert in DB
                if(data.count > 0){
                    
                    let qty = inventory.insertProducts(data)
                    print("Cantidad insertadas \(qty)")
                }
            })
            
        }else{
            print(ServicesDataError.EmptyToken)
        }
    }
    
    func getToken(username: String, password: String){
    
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Content-Length" : "50"
        ]
        
        let parameters = [
            "username"   :  username,
            "password"   :  password,
            "grant_type" : "password"
        ]
        
        self.jsonRequest(ResoursePath.Token.description, method: Alamofire.Method.POST ,header: headers, parameter: parameters ) { (JSON) -> () in
            
            print(JSON)
            if let token = JSON["access_token"].string {
            
                let userToken = UserData(username: "", password: "", localPassword: "", token: token, name: "")
               //save token
                 UserDefaultModel().addDataUser(userToken)
               
            }else{
                print(ServicesDataError.UserFail)
            }
        }
    }
    
    
    //Json Request.
    internal func jsonRequest(resource: String, method: Alamofire.Method? = .GET, header:[String:String]?=[:] , parameter:[String:AnyObject]?=[:], responseData: (JSON) -> ()) {
        
        let longUrl  = "\(baseUrl)/\(prefixUrl)\(resource)"
        
        
        Alamofire.request(method!, longUrl, headers: header, parameters: parameter, encoding: .URL )
            .responseJSON { response in
                
              //  print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.result)   // result of response serialization
                
                if let response = response.result.value {
                    
                    responseData(JSON(response))
                }
        }
        
    }
    
}