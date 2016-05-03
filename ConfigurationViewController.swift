//
//  ConfigurationViewController.swift
//  JustOrders
//
//  Created by Victor Santos on 4/6/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import UIKit

class ConfigurationViewController:UIViewController, CustomAlertViewDelegate {
    
    @IBOutlet weak var serverUrl: UITextField!
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var userAPI: UITextField!
    @IBOutlet weak var passwordAPI: UITextField!
    
    @IBOutlet weak var localUser: UITextField!
    @IBOutlet weak var localPassword: UITextField!
    @IBOutlet weak var terminalNumber: UITextField!
    @IBOutlet weak var token: UITextView!
    
    
    //Company
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var companyPhone: UITextField!
    @IBOutlet weak var companyAddress: UITextField!
    @IBOutlet weak var companyCity: UITextField!
    @IBOutlet weak var companyRegion: UITextField!
    @IBOutlet weak var companyTaxId: UITextField!
    @IBOutlet weak var companyEmail: UITextField!
    @IBOutlet weak var companyWeb: UITextField!
    
    //Other Config
    @IBOutlet weak var discountSW: UISwitch!
    @IBOutlet weak var changePriceSW: UISwitch!
    @IBOutlet weak var sendModeSW: UISwitch!
    
    //Administrator
    @IBOutlet weak var administratorPassword: UITextField!
    @IBOutlet weak var orderSecuences: UITextField!
    @IBOutlet weak var clientSecuences: UITextField!
    @IBOutlet weak var lastOrderSec: UILabel!
    
    
    //Printer
    
    @IBOutlet weak var footerPrint: UITextView!
    
    
    //MARK: ACTIONS
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func administratorPasswordAction(sender: AnyObject) {
        
        let admPwd = administratorPassword.text!
        
        UserDefaultModel().setAdministratorPassword(admPwd)
        
        let orderSec = orderSecuences.text!
        let clientSec = clientSecuences.text!
        
        UserDefaultModel().setOrderSec(orderSec)
        UserDefaultModel().setClientSec(clientSec)
        
    }
    
    
    
    @IBAction func refreshTokenAction(sender: AnyObject) {
       
        self.view.showLoading()
        
        let data = UserDefaultModel().getDataUser()
        
        ServicesData().getToken(data.username, password: data.password){ (error: ServicesDataError) in
            
            self.view.hideLoading()
            
            switch error {
                
            case ServicesDataError.UserFail:
                self.view.showCustomeAlert(AlertViewType.error, title: "Usuario Inválido", message: "Usuario o clave son incorrecto por favor revisar")
                break
                
            case ServicesDataError.ServerFail:
                self.view.showCustomeAlert(AlertViewType.error, title: "Server inválido", message: "La dirección del servidor es inválida o el servidor no responde")
                break
                
            default:
                //Sucess
                self.view.showCustomeAlert(AlertViewType.information, title: "Exito!", message: "Conexión exitosa, se ha actualizado el tocken")
                
               self.token.text = data.token
                
                break
            }
            
        }
        
    
    }
    
    @IBAction func userAndServer(sender: AnyObject) {
        
        let userDefault = UserDefaultModel()
        
        let username = userAPI.text!
        let password = passwordAPI.text!
       // let localpass = localPassword.text!
        let localuser = localUser.text!
        let terminal = terminalNumber.text!
        let server = serverUrl.text!
        let serverPort = port.text!
        
        guard let localpass:String = localPassword.text! where validateLongField(4, field: localPassword) else{
            return
        }
        
        let data =  UserData(username: username, password: password, localPassword: localpass, token: "", localUser: localuser, terminal: terminal, serverUrl: server, serverPort: serverPort)
       
       userDefault.addDataUser(data)
        
    }
    
    
    @IBAction func companyAction(sender: AnyObject) {
        
        let name = companyName.text!
        let phone = companyPhone.text!
        let address = companyAddress.text!
        let city = companyCity.text!
        let region = companyRegion.text!
        let taxId = companyTaxId.text!
        let email = companyEmail.text!
        let web = companyWeb.text!
        let footer = footerPrint.text!
        
        let data = CompanyData(name: name, phone: phone, address: address, city: city, region: region, taxId: taxId, email: email, web: web, footer: footer)
        
        UserDefaultModel().setCompany(data)
        
    }
    
    @IBAction func configurationAction(sender: AnyObject) {
        
        let discount = discountSW.on
        let chagePrice = changePriceSW.on
        let sendMode = sendModeSW.on
        
        let data = Configurations(discount: discount, changePrice: chagePrice, sendMode: sendMode)
        
        UserDefaultModel().setConfiguration(data)
        
    }
    
    @IBAction func updateStores(sender: AnyObject) {
        
     self.view.showLoading()
        
        let serviceData = ServicesData()
        
        do{
            
        
      try serviceData.getDataStores { (qty) in
            
            self.view.hideLoading()
           self.view.showCustomeAlert(title: "Store Sincronizado", message: "Cantidad: \(qty)")
            
        }
        }catch{
            print("No se pudo sincronizar los Stores: \(error)")
            
            self.view.hideLoading()
            self.view.showCustomeAlert(AlertViewType.error, title: ":(", message: "Ocurrión algun problema al sincronizar los Stores")
        }
        self.view.hideLoading()
        
    }
    
    func alertBack(controller:CustomAlertView, acction:Bool){
    
    }
    
    
    //MARK: Load content
    
    func loadUserAndServer(){
        
        let data = UserDefaultModel().getDataUser()
        
        userAPI.text = data.username
        passwordAPI.text = data.password
        localPassword.text = data.localPassword
        localUser.text = data.localUser
        terminalNumber.text = data.terminal
        serverUrl.text = data.serverUrl
        port.text = data.serverPort
        
    }
    
    func loadCompany(){
        
        let data = UserDefaultModel().getCompany()
        
        companyName.text = data.name
        companyPhone.text = data.phone
        companyAddress.text = data.address
        companyCity.text = data.city
        companyRegion.text = data.region
        companyTaxId.text = data.taxId
        companyEmail.text = data.email
        companyWeb.text = data.web
        footerPrint.text = data.footer
        
    }
    
    
    func loadConfiguration() {
        let data = UserDefaultModel().getConfiguration()
        
        discountSW.setOn(data.discount, animated: true)
        changePriceSW.setOn(data.changePrice, animated: true)
        sendModeSW.setOn(data.discount, animated: true)
    }
    
    func loadAdministrator(){
        administratorPassword.text = UserDefaultModel().getAdministratorPassword()
        orderSecuences.text = UserDefaultModel().getOrderSec()
        clientSecuences.text = UserDefaultModel().getClientSec()
        lastOrderSec.text = "\(OrderModel().getLastOrderNumber())"
        
    }
    
    //MARK: HELPERS
    
    func validateLongField(long: Int, field:UITextField)-> Bool{
       
        //Validate 4 digit password
        let longPass = localPassword.text!
        
        if longPass.length <= long {
            
            //Normal Color
            field.textColor = UIColor(red:0.64, green:0.69, blue:0.78, alpha:1.00)
            
            return true
        }else{
            //Red Color
            field.deleteBackward()
            field.textColor = UIColor(red:0.92, green:0.36, blue:0.38, alpha:1.00)
         }
        
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadUserAndServer()
        loadCompany()
        loadConfiguration()
        loadAdministrator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
