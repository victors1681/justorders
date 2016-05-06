//
//  ReciboViewController.m
//  test
//
//  Created by Victor Santos on 6/26/15.
//  Copyright (c) 2015 Victor Santos. All rights reserved.
//

#import "FormatosZebra.h"
#import "JustOrders-Swift.h"
#import "ConexionDB.h"

@implementation FormatosZebra
@synthesize status;

-(BOOL)printPedidosZebra:(id<NSObject,ZebraPrinter>)printer andNoDocumento:(NSString *)NoDocumento {
    
    NSError *error = nil;
    
    UserDefaultModel *user = [[UserDefaultModel alloc] init];
    
    NSDictionary *datosEmpresa = [user getCompanyObj];
    
    ConexionDB *conDB = [[ConexionDB alloc]init];
    
     //Pedido *datosPedido = [[Pedido alloc]init];
    NSMutableDictionary *Datos = [[NSMutableDictionary alloc]init];
    
    NSString *orderId = @"";
    NSString *clientId = @"";
    NSString *terminalNo = @"";
    NSString *totalOrder = @"";
    NSString *subTotal = @"";
    NSString *amountPaid = @"";
    NSString *amountChange = @"";
    NSString *paymentMethod = @"";
    NSString *totalDiscount = @"";
    NSString *discountPercent = @"";
    NSString *documentType = @"";
    NSString *ncf = @"";
    NSString *orderNote = @"";
    NSString *userName = @"";
    NSString *date = @"";
    NSString *sendTo = @"";
    
    NSArray *dataDetail = [[NSArray alloc]init];
    
    
    NSString *clientName = @"";
    NSString *email = @"";
    NSString *address = @"";
    NSString *phone = @"";
    NSString *city = @"";
    NSString *taxId = @"";
    
    
    if (NoDocumento > 0) {
        //buscar un pedido especifico
        [Datos setObject:@"byID" forKey:@"Sincronizados"];
        [Datos setObject:@"0" forKey:@"Filtro"];
        [Datos setObject:NoDocumento forKey:@"ID"];
     
        status = @"Re-IMPRESION";
        //datosPedidosArray = [datosPedido getPedidos:Datos];
    }else{
        //Busca e imprime clientIdel último pedido
        
        status = @"ORIGINAL";
        
        OrderModel *orderObj = [[OrderModel alloc]init];
        NSDictionary *dataOrder = [orderObj getLastOrderObj];
        
        NSLog(@"Client id: %@",dataOrder[@"selection"]);
       
        clientName = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"clientName"]];
        orderId = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"orderId"]];
        clientId = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"clientId"]];
        terminalNo = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"terminalNo"]];
        totalOrder = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"totalOrder"]];
        subTotal = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"subTotal"]];
        amountPaid = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"amountPaid"]];
        amountChange = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"amountChange"]];
        paymentMethod = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"paymentMethd"]];
        totalDiscount = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"totalDiscount"]];
        discountPercent = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"discountPercent"]];
        documentType = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"documentType"]];
        ncf = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"ncf"]];
        orderNote = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"orderNote"]];
        userName = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"userName"]];
        date = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"date"]];
        sendTo = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"sendTo"]];
  
        //--------------- CLIENTE-----------------
        
        email = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"email"]];
        address = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"address"]];
        phone = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"phone"]];
        city = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"city"]];
        taxId =  [[NSString alloc] initWithFormat:@"%@", dataOrder[@"taxId"]];
        
        
        //Order Detail
        dataDetail = [orderObj  getOrderDetailObj:[dataOrder[@"orderId"] intValue]];
        
         
    }
    
 
 
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
    //NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    //Clean Buffer
   // [[printer getToolsUtil] reset:&error];
    
   NSString *header = [NSString stringWithFormat:
                      //  @"^XA^POI^PW828^MNN^LL220^LH0^CI28,0" \
                       
                       @"^XA^POI^PW828^MNN^LL220^LH0,0" \
                        //Nombre de la Empresa
                      //  @"^FO5,50" \
                      //  @"^A0,N,25,22" \
                      //  @"^FD%@^FS" \
                       
                       @"^FO5,50" \
                       @"^ADN,36,20" \
                       @"^FD%@^FS" \
                       
                       //Status - Original O Reimpresión
                       @"^FO390,50" \
                       @"^A0N,25,22" \
                       @"^FD%@^FS" \
                       
                        //DIRECCION
                        @"^FO5,85" \
                        @"^A0N,24,21" \
                        @"^FD%@^FS" \
                        //CIUDAD
                        @"^FO5,110" \
                        @"^A0N,24,21" \
                        @"^FD%@^FS" \
                       
                       //TELEFONO HEADER
                       @"^FO5,140" \
                       @"^A0N,19,15" \
                       @"^FDTEL.:^FS" \
                       //TELEFONO
                       @"^FO60,140" \
                       @"^A0,19,18" \
                       @"^FD%@^FS" \
                       
                       //FAX HEADER
                       @"^FO5,160" \
                       @"^A0,19,15" \
                       @"^FDEMAIL:^FS" \
                       //FAX
                       @"^FO60,160" \
                       @"^A0,19,18" \
                       @"^FD%@^FS" \
                       
                       
                       //RNC HEADER
                       @"^FO5,180" \
                       @"^A0,19,15" \
                       @"^FDRNC :^FS" \
                       //RNC
                       @"^FO60,180" \
                       @"^A0,19,18" \
                       @"^FD%@^FS" \
                       
                       //DIVISION
                       @"^FO5,210" \
                       @"^GB820,1,1,B,0^FS^XZ",
                       
                       datosEmpresa[@"name"],
                       @"",//status,
                       datosEmpresa[@"address"],
                       datosEmpresa[@"city"],
                       datosEmpresa[@"phone"],
                       datosEmpresa[@"web"],
                       datosEmpresa[@"taxId"]  ];
    
   [[printer getToolsUtil] sendCommand:header error:&error];
    
    NSString *header2 = [NSString stringWithFormat:
                        @"^XA^POI^LL190^CI28" \
                        //NO PEDIDO
                        @"^FO5,10" \
                        @"^A0,19,15" \
                        @"^FDNO.PEDIDO:^FS" \
                        
                        @"^FO140,10" \
                        @"^A0,19,18" \
                        @"^FD%@^FS" \
                        
                        //CONDICION DE PAGO
                        @"^FO5,30" \
                        @"^A0,19,15" \
                        @"^FDFORMA PAGO:^FS" \
                        
                        @"^FO140,30" \
                        @"^A0,19,18" \
                        @"^FD%@^FS" \
                        
                        
                        //VENDEDOR
                        @"^FO5,50" \
                        @"^A0,19,18" \
                        @"^FDVENDEDOR  :^FS" \
                        
                        @"^FO140,50" \
                        @"^A0,19,18" \
                        @"^FD(%@) %@^FS" \
                         
                         
                         //TELEFONO
                         @"^FO5,70" \
                         @"^A0,19,15" \
                         @"^FDTELEFONO  :^FS" \
                         
                         @"^FO140,70" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         //NO.CUENTA
                         @"^FO5,90" \
                         @"^A0,19,15" \
                         @"^FDNO. CUENTA :^FS" \
                         
                         @"^FO140,90" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         //CLIENTE
                         @"^FO5,110" \
                         @"^A0,19,15" \
                         @"^FDCLIENTE :^FS" \
                         
                         @"^FO140,110" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                        
                         //DIRECCION
                         @"^FO5,130" \
                         @"^A0,19,15" \
                         @"^FDDIRECCION :^FS" \
                         
                         @"^FO140,130" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         
                         //FECHA
                         @"^FO5,150" \
                         @"^A0,19,15" \
                         @"^FDFECHA :^FS" \
                         
                         @"^FO140,150" \
                         @"^A0,19,18" \
                         @"^FD%@ ^FS" \
                         
                         
                        //DIVISION
                        @"^FO5,170" \
                        @"^GB820,1,1,B,0^FS^XZ",
                         orderId,
                         @"", //currenPedido.pCondicionPago,
                         terminalNo, //currenPedido.pVendedor,
                         userName, //currenCliente.cVendedor,
                         phone,
                         clientId,
                         clientName,
                         address,
                        [conDB formatoFechaHora:date]];
    
    [[printer getToolsUtil] sendCommand:header2 error:&error];
    
    NSString *headerDetalle = [NSString stringWithFormat:
                               @"^XA^POI^LL40" \
                        
                               @"^FO5,10" \
                               @"^A0,21,17" \
                               @"^FDCANTIDAD^FS" \
                        
                               @"^FO120,10" \
                               @"^A0,21,17" \
                               @"^FDTIPO ^FS" \
                               
                               @"^FO270,10" \
                               @"^A0,21,17" \
                               @"^FDPRECIO ^FS" \
                               
                               @"^FO430,10" \
                               @"^A0,21,17" \
                               @"^FDTOTAL ^FS" \
                     
                               //DIVISION
                               @"^FO5,30" \
                               @"^GB820,1,1,B,0^FS^XZ"];
    
    [[printer getToolsUtil] sendCommand:headerDetalle error:&error];
    
    
    float total = 0;
    int renglones = 0;
    float articulos = 0.0;
    float itbis = 0;
    int count = 0;
    
    for (int i = 0; i < dataDetail.count; i++) {
        
        NSDictionary *currenDetalle = [dataDetail objectAtIndex:i];
        
        NSString *code = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"code"]];
        NSString *description = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"description"]];
        NSString *unit = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"unit"]];
        NSString *amountTax = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"amountTax"]];
        NSString *quantity = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"quantity"]];
        NSString *price = [[NSString alloc] initWithFormat:@"%@", currenDetalle[@"price"]];
       
        
        //NSString *Nombre = currenDetalle.peDescripcion;
        float Cantidad = [quantity floatValue];
        float Precio = [price floatValue];
        float Impuesto = [amountTax floatValue];
        
        
        
        float subtotal= 0;
        
        NSString *lineItem =
        @"^XA^POI^LL50" \
       // @"^XA^POI^LL50^CI28" \
        
        @"^FO5,10"\
        @"^ACN" \
        @"^FD(%@)-%@^FS"\
        
        //CANTIDAD
        @"^FO8,30"\
        @"^ACN" \
        @"^FD%@^FS" \
        
        //TIPO
        @"^FO120,30"\
        @"^ACN" \
        @"^FD%@^FS" \
        
        //PRECIO
        @"^FO275,30"\
        @"^ACN" \
        @"^FD$%@^FS" \
        
        //TOTAL
        @"^FO435,30"\
        @"^ACN" \
        @"^FD$%@^FS" \
        
        @"^XZ";
        
        subtotal = Cantidad * Precio;
        total +=subtotal;
        renglones ++;
        articulos += Cantidad;
        itbis += Cantidad * Impuesto ;
        
        
        //Eliminar espacios en blanco
        NSString *codigo = [code stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
        
        
        NSString *lineItemWithVars = [NSString stringWithFormat:lineItem,
                                      codigo,
                                      description,
                                      quantity,
                                      unit,
                                     [conDB formatoNumero: [NSString stringWithFormat:@"%0.2f",Precio]],
                                      [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",subtotal]
                                   ]];
        
        [[printer getToolsUtil] sendCommand:lineItemWithVars error:&error];
       
        //Esta opción es para solicionar el problema del buffer de la impresora y continue con la impresión constante
        if (count > 3) {
            sleep(1);
            count = 0;
        }
        count ++;
        
        if(error != nil) {
            NSLog(@"Error Impresión");
        }
        
    }
    
    
    
    
    float totalGeneral = (total - [discountPercent floatValue]) + itbis;
    float pendiente = totalGeneral - [amountPaid floatValue];
    
    if(pendiente < 0) {
        pendiente = 0.0;
    }
    
    NSString *totales ;
                         
        totales = [NSString stringWithFormat:
                   @"^XA^POI^LL240" \
                   
                   //RENGLONES
                   @"^FO270,20" \
                   @"^ACN" \
                   @"^FDARTICULOS:^FS" \
                   
                   @"^FO400,20" \
                   @"^ACN" \
                   @"^FD%@^FS" \
                   
                   //SUB TOTAL
                   @"^FO270,40" \
                   @"^ACN" \
                   @"^FDSUB-TOTAL: ^FS" \
                   
                   @"^FO400,40" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   //DESCUENTO
                   @"^FO270,60" \
                   @"^ACN" \
                   @"^FDDESCUENTO:^FS" \
                   
                   @"^FO400,60" \
                   @"^ACN" \
                   @"^FD$%@^FS" \
                   
                   //ITBIS
                   @"^FO270,80" \
                   @"^ACN" \
                   @"^FDITBIS: ^FS" \
                   
                   @"^FO400,80" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   //TOTAL
                   @"^FO270,100" \
                   @"^ACN" \
                   @"^FDTOTAL: ^FS" \
                   
                   @"^FO400,100" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   //Abono
                   @"^FO270,120" \
                   @"^ACN" \
                   @"^FDABONO: ^FS" \
                   
                   @"^FO400,120" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   //Change
                   @"^FO270,140" \
                   @"^ACN" \
                   @"^FDCAMBIO: ^FS" \
                   
                   @"^FO400,140" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   //Balance Pendiente
                   @"^FO270,160" \
                   @"^ACN" \
                   @"^FDPENDIENTE: ^FS" \
                   
                   @"^FO400,160" \
                   @"^ACN" \
                   @"^FD$%@ ^FS" \
                   
                   
                   //DIVISION
                   @"^FO150,190" \
                   @"^A0,22,17" \
                   @"^FD******FIN DEL PEDIDO****** ^FS"\
                   
                   
                   //DIVISION
                   @"^FO30,210" \
                   @"^ACN" \
                   @"^FDPara recoger en: ^FS"\
                   
                   @"^FO220,210" \
                   @"^A0N,24,21" \
                   @"^FD%@^FS^XZ",
                   
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",articulos]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",total]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[totalDiscount floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",itbis]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",totalGeneral]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[amountPaid floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[amountChange floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f", pendiente]],
                   sendTo
                   ];
    
    
     
        [[printer getToolsUtil] sendCommand:totales error:&error];
   
    
    NSString *footer = [NSString stringWithFormat:
                         @"^XA^POI^LL470" \
                        
                        //@"^XA^POI^LL460" \
                        //@"^XA^POI^LL460^CI28"
                        
                        //Pie de Recibo
                        @"^FO015,10" \
                        @"^A0,24,20" \
                        @"^FB480,4,,j"\
                        @"^FD%@^FS" \
                        
                         //Pie de Recibo
                         @"^FO015,50" \
                         @"^A0,19,16" \
                         @"^FB480,4,,j"\
                         @"^FD%@^FS" \
                        
                      //  @"^FO05,50" \
                        @"^A0,19,16" \
                        @"^FDdomingo. Todo pedido comprado queda sujeto a aceptación final por part de los^FS" \
                        
                      //  @"^FO05,70" \
                        @"^A0,19,16" \
                        @"^FDvendedores a previa veenta de la mercancía ofrecida. Flete por cuenta del comprador^FS" \
                   
                        
                        //DIVISION
                        @"^FO90,250" \
                        @"^GB390,1,1,B,0^FS"\
                        
                        //FIrma
                         @"^FO180,260" \
                         @"^A0,21,17" \
                         @"^FDFIRMA DEL COMPRADOR ^FS" \
                         
                        
                        //DIVISION
                        @"^FO90,380" \
                        @"^GB390,1,1,B,0^FS"\
                        
                        //FIrma
                        @"^FO185,390" \
                        @"^A0,21,17" \
                        @"^FDFIRMA DEL VENDEDOR ^FS"\
                        
                        //FIrma SOFTWARE
                        @"^FO160,410" \
                        @"^A0,18,16" \
                        @"^FDDevelop by: www.mobile-seller.com ^FS" \
                        
                        //Space
                        @"^FO160,420" \
                        @"^A0,18,16" \
                        @"^FD^FS" \

                        @"^XZ", orderNote, datosEmpresa[@"footer"]];
    
    
    
    [[printer getToolsUtil] sendCommand:footer error:&error];
    
    sleep(2);
    
    NSLog(@"FIN DEL REPORTE DEL PEDIDO");
    
    if(error != nil) {
         return false;
    }
    return true;
    
}


-(NSString*) getLanguageName :(PrinterLanguage)language {
    if(language == PRINTER_LANGUAGE_ZPL){
        return @"ZPL";
    } else {
        return @"CPCL";
    }
}




@end
