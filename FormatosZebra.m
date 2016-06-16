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
    NSString *totalTax = @"";
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
    int taxeable = 0;
    
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
        totalTax = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"totalTax"]];
        amountPaid = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"amountPaid"]];
        amountChange = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"amountChange"]];
        paymentMethod = [[NSString alloc] initWithFormat:@"%@", dataOrder[@"paymentMethod"]];
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
        taxeable = [[[NSString alloc] initWithFormat:@"%@", dataOrder[@"taxeable"]] intValue];
        
        //Order Detail
        dataDetail = [orderObj  getOrderDetailObj:[dataOrder[@"orderId"] intValue]];
        
        //Translating
        if([paymentMethod isEqualToString:@"Cash"]){
            paymentMethod = @"Efectivo";
        }else{
            paymentMethod = @"Tarjeta";
        }
         
    }
    
 
 
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
    
    //Clean Buffer
   // [[printer getToolsUtil] reset:&error];
    
   NSString *valorFiscal = @"";
    
    if (taxeable == 1) {
        valorFiscal = @"CREDITO FISCAL";
    }
    
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
                       
                       //Factura con valor fiscal Derecha
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
                       valorFiscal,//status,
                       datosEmpresa[@"address"],
                       datosEmpresa[@"city"],
                       datosEmpresa[@"phone"],
                       datosEmpresa[@"web"],
                       datosEmpresa[@"taxId"]  ];
    
   [[printer getToolsUtil] sendCommand:header error:&error];
    
    NSString *header2 = [NSString stringWithFormat:
                        @"^XA^POI^LL230^CI28" \
                         
                         //TITULO
                         @"^FO210,10" \
                         @"^A0N,25,22" \
                         @"^FD%s^FS" \
                         
                         
                        //NO PEDIDO
                        @"^FO5,40" \
                        @"^A0,19,15" \
                        @"^FDNO.PEDIDO:^FS" \
                        
                        @"^FO140,40" \
                        @"^A0,19,18" \
                        @"^FD%@^FS" \
                        
                        //CONDICION DE PAGO
                        @"^FO5,60" \
                        @"^A0,19,15" \
                        @"^FDFORMA PAGO:^FS" \
                        
                        @"^FO140,60" \
                        @"^A0,19,18" \
                        @"^FD%@^FS" \
                        
                        
                        //VENDEDOR
                        @"^FO5,80" \
                        @"^A0,19,18" \
                        @"^FDVENDEDOR  :^FS" \
                        
                        @"^FO140,80" \
                        @"^A0,19,18" \
                        @"^FD(%@) %@^FS" \
                         
                         
                         //TELEFONO
                         @"^FO5,100" \
                         @"^A0,19,15" \
                         @"^FDTELEFONO  :^FS" \
                         
                         @"^FO140,100" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         //NO.CUENTA
                         @"^FO5,120" \
                         @"^A0,19,15" \
                         @"^FDNO. CUENTA :^FS" \
                         
                         @"^FO140,120" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         //CLIENTE
                         @"^FO5,140" \
                         @"^A0,19,15" \
                         @"^FDCLIENTE :^FS" \
                         
                         @"^FO140,140" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                        
                         //DIRECCION
                         @"^FO5,160" \
                         @"^A0,19,15" \
                         @"^FDDIRECCION :^FS" \
                         
                         @"^FO140,160" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         //RNC CLIENTE
                         @"^FO5,180" \
                         @"^A0,19,15" \
                         @"^FDRNC :^FS" \
                         
                         @"^FO140,180" \
                         @"^A0,19,18" \
                         @"^FD%@^FS" \
                         
                         
                         //FECHA
                         @"^FO5,200" \
                         @"^A0,19,15" \
                         @"^FDFECHA :^FS" \
                         
                         @"^FO140,200" \
                         @"^A0,19,18" \
                         @"^FD%@ ^FS" \
                         
                         
                        //DIVISION
                        @"^FO5,220" \
                        @"^GB820,1,1,B,0^FS^XZ",
                         "PEDIDO",
                         orderId,
                         paymentMethod, //currenPedido.pCondicionPago,
                         terminalNo, //currenPedido.pVendedor,
                         userName, //currenCliente.cVendedor,
                         phone,
                         clientId,
                         clientName,
                         address,
                         taxId,
                        [conDB formatoFechaHoraCorto:date]];
    
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
    
    float articulos = 0.0;
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
        float Precio = [price floatValue] + [amountTax floatValue];
        //float Impuesto = [amountTax floatValue];
        
        
        
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
       // total +=subtotal;
       //renglones ++;
        articulos += Cantidad;
        //itbis += Cantidad * Impuesto ;
        
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
    
    
    
    
    float totalGeneral = ([subTotal floatValue] - [totalDiscount floatValue]) + [totalTax floatValue];
    float pendiente = totalGeneral - [amountPaid floatValue];
    
    if(pendiente < 0) {
        pendiente = 0.0;
    }
    
    NSString *totales ;
                         
        totales = [NSString stringWithFormat:
                   @"^XA^POI^LL270" \
                   
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
                   @"^FO30,240" \
                   @"^ACN" \
                   @"^FDPara recoger en: ^FS"\
                   
                   @"^FO225,235" \
                   @"^A0N,30,26" \
                   @"^FD%@^FS^XZ",
                   
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",articulos]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[subTotal floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[totalDiscount floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[totalTax floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[totalOrder floatValue] - [totalDiscount floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[amountPaid floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",[amountChange floatValue]]],
                   [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f", pendiente]],
                   sendTo
                   ];
    
    
    [[printer getToolsUtil] sendCommand:totales error:&error];
   
    
    NSString *footer = [NSString stringWithFormat:
                         @"^XA^POI^LL500" \
                        
                        //@"^XA^POI^LL460" \
                        //@"^XA^POI^LL460^CI28"
                        
                        //Pie de Recibo
                        @"^FO015,40" \
                        @"^A0,24,20" \
                        @"^FB480,4,,j"\
                        @"^FD%@^FS" \
                        
                         //Pie de Recibo
                         @"^FO015,110" \
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
