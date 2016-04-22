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
    
    //func getToken(username: String, password: String)
}


private enum ResoursePath {
    
    
    case Inventory(filtro:String)
    case Clients(vendedorID:String, filtro: String)
    case SendOrders
    case Token
    case Value

    var description: String{
        
        switch self{
        case .Inventory(let filtro)  : return ("api/Productos?FILTRO=\(filtro)")
        case .Clients(let vendedorID, let filtro) : return ("/Clientes?ID_VENDEDOR=\(vendedorID)&FILTRO=\(filtro)")
        case .SendOrders : return ("api/Pedidos")
        case .Token : return ("token")
        case .Value : return ("api/values")
            
        }
        
    }

}


enum ServicesDataError:ErrorType {
 
    case EmptyToken
    case UserFail
    case ServerFail
    case NoError
}

class ServicesData:ServicesDataType {
    
    internal let baseUrl = UserDefaultModel().getServerPath()
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
                let data  = inventory.convertJson(JSON!["data"])
                
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
    
    func getToken(username: String, password: String, completion: (error: ServicesDataError) -> Void) {
    
        
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
            
            if JSON != nil {
                
                print(JSON!)
            if let token = JSON!["access_token"].string {
            
                let userToken = UserData(username: "", password: "", localPassword: "", token: token, localUser: "", terminal: "", serverUrl: "", serverPort: "")
                //save token
                 UserDefaultModel().addDataUser(userToken)
                
                completion(error: .NoError) // Success
              
            }else if JSON!["error"].stringValue == "invalid_grant" {
                print(JSON!)
                
               completion(error: .UserFail)
            }
            }else{
                completion(error:.ServerFail)
            }
        
        }
        
    }
    
    func sendOrders(json:JSON, responseData:(JSON?)-> ()) {
        
        let headers = [
            "Authorization" : "bearer \(gobalToken)",
            "Content-Type": "application/json"
        ]
        
        let longUrl  = "\(baseUrl)/\(prefixUrl)\(ResoursePath.SendOrders.description)"
        
        print(json.dictionaryObject!)

        Alamofire.request(.POST, longUrl, headers: headers, parameters:json.dictionaryObject!, encoding:.JSON)
            .responseJSON { response in
                
                print(response.request)
                
                if let response = response.result.value {
                    //print(response.result) // URL response
                    print(response)   // result of response serialization
                    
                    responseData(JSON(response))
                }else{
                    if response.response == nil {
                        print(ServicesDataError.ServerFail)
                        responseData(nil)
                    }
                }
        }    
 
 }
 
    //Json Request.
    internal func jsonRequest(resource: String, method: Alamofire.Method? = .GET, header:[String:String]?=[:] , parameter:[String:AnyObject]?=[:], responseData: (JSON?) -> ()) {
        
        let longUrl  = "\(baseUrl)/\(prefixUrl)\(resource)"
        
        Alamofire.request(method!, longUrl, headers: header, parameters: parameter, encoding: .URL )
            .responseJSON { response in
                
                
                
                if let response = response.result.value {
                    //print(response.response) // URL response
                    //print(response.result)   // result of response serialization
                    
                    responseData(JSON(response))
                }else{
                    if response.response == nil {
                        print(ServicesDataError.ServerFail)
                        responseData(nil)
                    }
                }
        }
        
    }
    
}