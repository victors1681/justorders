//
//  FormatosZebra.swift
//  JustOrders
//
//  Created by Victor Santos on 4/29/16.
//  Copyright © 2016 Victor Santos. All rights reserved.
//

import Foundation


func printPedidosZebra(printer:<NSObjectProtocol:ZebraPrinter>, docuemnt: String)->Bool {
    
 
    return true
}

//-(BOOL)printPedidosZebra:(id<NSObject,ZebraPrinter>)printer andNoDocumento:(NSString *)NoDocumento {
    









//
//  ReciboViewController.m
//  test
//
//  Created by Victor Santos on 6/26/15.
//  Copyright (c) 2015 Victor Santos. All rights reserved.
//

    /*
#import "FormatosZebra.h"
#import "JustOrders-Swift.h"

@implementation FormatosZebra
@synthesize status;

-(BOOL)printPedidosZebra:(id<NSObject,ZebraPrinter>)printer andNoDocumento:(NSString *)NoDocumento {
    
    NSError *error = nil;
    
    UserDefaultModel *user = [[UserDefaultModel alloc] init];
    
    NSDictionary *datosEmpresa = [user getCompanyObj];
    
    
    
    
    //Pedido *datosPedido = [[Pedido alloc]init];
    NSMutableDictionary *Datos = [[NSMutableDictionary alloc]init];
    NSMutableArray *datosPedidosArray = [[NSMutableArray alloc] init];
    
    
    if (NoDocumento > 0) {
        //buscar un pedido especifico
        [Datos setObject:@"byID" forKey:@"Sincronizados"];
        [Datos setObject:@"0" forKey:@"Filtro"];
        [Datos setObject:NoDocumento forKey:@"ID"];
        
        status = @"Re-IMPRESION";
        datosPedidosArray = [datosPedido getPedidos:Datos];
    }else{
        //Busca e imprime el último pedido
        [Datos setObject:@"UltimoPedido" forKey:@"Sincronizados"];
        [Datos setObject:@"0" forKey:@"Filtro"];
        
        status = @"ORIGINAL";
        datosPedidosArray = [datosPedido getPedidos:Datos];
    }
    
    
    Pedido *currenPedido = [datosPedidosArray objectAtIndex:0];
    
    //--------------- CLIENTE-----------------
    Clientes *datosCliente = [[Clientes alloc]init];
    NSMutableArray *datosClienteArray = [datosCliente DataDB:currenPedido.pCliente nombre:@"" andCiudad:@"" andActivos:@"" ];
    
    Clientes *currenCliente = [datosClienteArray objectAtIndex:0];
    
    //---------------Detalle pedido-----------
    
    PedidoDetalle *datosPedidoDetalle = [[PedidoDetalle alloc]init];
    NSMutableArray *datosDetalleArray = [datosPedidoDetalle getDetallePedidos:@"" id_Pedido:currenPedido.pIDPedido];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
    // NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    //Clean Buffer
    // [[printer getToolsUtil] reset:&error];
    
    NSString *header = [NSString stringWithFormat:
    //  @"^XA^POI^PW828^MNN^LL220^LH0^CI28,0" \
    
    @"^XA^POI^PW828^MNN^LL220^LH0,0" \
    //Nombre de la Empresa
    @"^FO5,50" \
    @"^A0,N,25,22" \
    @"^FD%@^FS" \
    //Status - Original O Reimpresión
    @"^FO390,50" \
    @"^A0,N,25,22" \
    @"^FD%@^FS" \
    
    //DIRECCION
    @"^FO5,80" \
    @"^A0,N,16,14" \
    @"^FD%@^FS" \
    //CIUDAD
    @"^FO5,110" \
    @"^A0,16,14" \
    @"^FD%@^FS" \
    //TELEFONO HEADER
    @"^FO5,140" \
    @"^A0,19,15" \
    @"^FDTEL.:^FS" \
    //TELEFONO
    @"^FO60,140" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    //FAX HEADER
    @"^FO5,160" \
    @"^A0,19,15" \
    @"^FDFAX. :^FS" \
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
    @"",// datosEmpresa[@"fax"],
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
    currenPedido.pIDPedido,
    currenPedido.pCondicionPago,
    currenPedido.pVendedor,
    currenCliente.cVendedor,
    currenCliente.cTelefono1,
    currenCliente.cCodigo,
    currenPedido.pNombreCliente,
    currenCliente.cDireccion,
    [conDB formatoFechaHoraEnglish:currenPedido.pFecha]];
    
    [[printer getToolsUtil] sendCommand:header2 error:&error];
    
    NSString *headerDetalle = [NSString stringWithFormat:
    @"^XA^POI^LL40" \
    
    @"^FO5,10" \
    @"^A0,21,17" \
    @"^FDCANTIDAD^FS" \
    
    @"^FO120,10" \
    @"^A0,21,17" \
    @"^FDMEDIDA ^FS" \
    
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
    float itbis = 0;
    int count = 0;
    for (int i = 0; i < datosDetalleArray.count; i++) {
        
        PedidoDetalle *currenDetalle = [datosDetalleArray objectAtIndex:i];
        
        //NSString *Nombre = currenDetalle.peDescripcion;
        float Cantidad = [currenDetalle.peCantidad floatValue];
        float Precio = [currenDetalle.pePrecio floatValue];
        float Impuesto = [currenDetalle.peImpuesto floatValue];
        
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
        
        //MEDIDA
        @"^FO125,30"\
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
        itbis += Cantidad * Impuesto ;
        
        
        //Eliminar espacios en blanco
        NSString *codigo = [currenDetalle.peCodigo stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceCharacterSet]];
        
        
        NSString *lineItemWithVars = [NSString stringWithFormat:lineItem,
        codigo,
        currenDetalle.peDescripcion,
        currenDetalle.peCantidad,
        currenDetalle.peUnidad,
        [conDB formatoNumero: currenDetalle.pePrecio],
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
    
    
    
    
    float totalGeneral = total + itbis;
    NSString *totales ;
    if ([dataUser getImpuestoSW]) {
        totales = [NSString stringWithFormat:
        @"^XA^POI^LL160" \
        
        //RENGLONES
        @"^FO270,20" \
        @"^ACN" \
        @"^FDRENGLONES:^FS" \
        
        @"^FO400,20" \
        @"^ACN" \
        @"^FD%d^FS" \
        
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
        @"^FD$0.00^FS" \
        
        //ITBIS
        @"^FO270,80" \
        @"^ACN" \
        @"^FDITEBIS: ^FS" \
        
        @"^FO400,80" \
        @"^ACN" \
        @"^FD$%@ ^FS" \
        
        //TOTAL
        @"^FO270,80" \
        @"^ACN" \
        @"^FDTOTAL: ^FS" \
        
        @"^FO400,100" \
        @"^ACN" \
        @"^FD$%@ ^FS" \
        
        
        //DIVISION
        @"^FO150,130" \
        @"^A0,22,17" \
        @"^FD******FIN DEL PEDIDO****** ^FS^XZ",
        renglones,
        [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",total]],
        [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",itbis]],
        [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",totalGeneral]]
        
        ];
    }else{ //ocultar campo de impuesto
        
        totales = [NSString stringWithFormat:
        @"^XA^POI^LL140" \
        
        //RENGLONES
        @"^FO270,20" \
        @"^ACN" \
        @"^FDRENGLONES:^FS" \
        
        @"^FO400,20" \
        @"^ACN" \
        @"^FD%d^FS" \
        
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
        @"^FD$0.00^FS" \
        
        
        
        //TOTAL
        @"^FO270,80" \
        @"^ACN" \
        @"^FDTOTAL: ^FS" \
        
        @"^FO400,80" \
        @"^ACN" \
        @"^FD$%@ ^FS" \
        
        
        //DIVISION
        @"^FO150,100" \
        @"^A0,22,17" \
        @"^FD******FIN DEL PEDIDO****** ^FS^XZ",
        renglones,
        [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",total]],
        [conDB formatoNumero:[NSString stringWithFormat:@"%0.2f",totalGeneral]]
        
        ];
        
    }
    
    //Opción deshabilitar total si el usuario lo desea.
    if (![dataUser getDeshabilitarTotal]) {
        
        [[printer getToolsUtil] sendCommand:totales error:&error];
    }
    
    NSString *footer = [NSString stringWithFormat:
    @"^XA^POI^LL460" \
    
    //@"^XA^POI^LL460" \
    //@"^XA^POI^LL460^CI28"
    
    
    //Nota
    @"^FO015,30" \
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
    @"^FDDevelop by: www.itsoluclick.com/mbs ^FS" \
    
    @"^XZ", datosEmpresa[@"piePedido"]];
    
    
    
    [[printer getToolsUtil] sendCommand:footer error:&error];
    
    sleep(2);
    
    NSLog(@"FIN DEL REPORTE DEL PEDIDO");
    
    if(error != nil) {
        return false;
    }
    return true;
    
}




-(BOOL)printRecibosZebra:(id<NSObject,ZebraPrinter>)printer andNoDocumento:(NSString *)NoDocumento
{
    NSError *error = nil;
    UserDefault *dataUser = [[UserDefault alloc]init];
    NSDictionary *datosEmpresa = [dataUser getEmpresa];
    ConexionDB *conDB = [[ConexionDB alloc]init];
    
    Cobros *datosCobros = [[Cobros alloc]init];
    
    NSMutableDictionary *Datos = [[NSMutableDictionary alloc]init];
    NSMutableArray *datosRecibosArray = [[NSMutableArray alloc] init];
    
    
    if (NoDocumento > 0) {
        //buscar un pedido especifico
        [Datos setObject:@"byID" forKey:@"Sincronizados"];
        [Datos setObject:@"0" forKey:@"Filtro"];
        [Datos setObject:NoDocumento forKey:@"ID"];
        
        status = @"Re-IMPRESION";
        
        datosRecibosArray = [datosCobros getRecibosProcesados:@"byID" cliente:NoDocumento];
    }else{
        //Busca e imprime el último pedido
        [Datos setObject:@"UltimoPedido" forKey:@"Sincronizados"];
        [Datos setObject:@"0" forKey:@"Filtro"];
        datosRecibosArray = [datosCobros getRecibosProcesados:@"UltimoCobro" cliente:@""];
        status = @"ORIGINAL";
        
    }
    
    
    Cobros *currenRecibo = [datosRecibosArray objectAtIndex:0];
    
    //--------------- CLIENTE-----------------
    Clientes *datosCliente = [[Clientes alloc]init];
    NSMutableArray *datosClienteArray = [datosCliente DataDB:currenRecibo.rCliente nombre:@"" andCiudad:@"" andActivos:@"" ];
    
    Clientes *currenCliente = [datosClienteArray objectAtIndex:0];
    
    //---------------Detalle Recibo-----------
    
    //RecibosDetalles *datosReciboDetalle = [[RecibosDetalles alloc]init];
    NSMutableArray *datosDetalleArray = [datosCobros getRecibosDetallesID:currenRecibo.rNoRecibo ];
    
    if ([currenRecibo.rAnulado integerValue] == 1) {
        status = @"ANULADO";
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm a"];
    // NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    // [dateFormatter release];
    
    
    NSString *header = [NSString stringWithFormat:
    @"^XA^POI^PW828^MNN^LL220^LH0^CI28,0" \
    //Nombre de la Empresa
    @"^FO5,50" \
    @"^A0,N,25,22" \
    @"^FD%@^FS" \
    //Status - Original O Reimpresión
    @"^FO390,50" \
    @"^A0,N,25,22" \
    @"^FD%@^FS" \
    
    //DIRECCION
    @"^FO5,80" \
    @"^A0,N,16,14" \
    @"^FD%@^FS" \
    //CIUDAD
    @"^FO5,110" \
    @"^A0,15,14" \
    @"^FD%@^FS" \
    //TELEFONO HEADER
    @"^FO5,140" \
    @"^A0,19,15" \
    @"^FDTEL.:^FS" \
    //TELEFONO
    @"^FO60,140" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    //FAX HEADER
    @"^FO5,160" \
    @"^A0,19,15" \
    @"^FDFAX. :^FS" \
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
    
    datosEmpresa[@"nombreEmpresa"],
    status,
    datosEmpresa[@"direccion"],
    datosEmpresa[@"ciudad"],
    datosEmpresa[@"telefono"],
    datosEmpresa[@"fax"],
    datosEmpresa[@"rnc"]  ];
    
    [[printer getToolsUtil] sendCommand:header error:&error];
    
    NSString *header2 = [NSString stringWithFormat:
    @"^XA^POI^LL160^CI28" \
    //NO RECIBO
    @"^FO5,10" \
    @"^A0,19,18" \
    @"^FDNO.RECIBO:^FS" \
    
    @"^FO140,10" \
    @"^ACN" \
    @"^FD%@-%@^FS" \
    
    
    
    //VENDEDOR
    @"^FO5,30" \
    @"^A0,19,18" \
    @"^FDVENDEDOR  :^FS" \
    
    @"^FO140,30" \
    @"^A0,19,18" \
    @"^FD(%@) %@^FS" \
    
    
    //TELEFONO
    @"^FO5,50" \
    @"^A0,19,15" \
    @"^FDTELEFONO  :^FS" \
    
    @"^FO140,50" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    //NO.CUENTA
    @"^FO5,70" \
    @"^A0,19,15" \
    @"^FDNO. CUENTA :^FS" \
    
    @"^FO140,70" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    //CLIENTE
    @"^FO5,90" \
    @"^A0,19,15" \
    @"^FDCLIENTE :^FS" \
    
    @"^FO140,90" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    //DIRECCION
    @"^FO5,110" \
    @"^A0,19,15" \
    @"^FDDIRECCION :^FS" \
    
    @"^FO140,110" \
    @"^A0,19,18" \
    @"^FD%@^FS" \
    
    
    //FECHA
    @"^FO5,130" \
    @"^A0,19,15" \
    @"^FDFECHA :^FS" \
    
    @"^FO140,130" \
    @"^A0,19,18" \
    @"^FD%@ ^FS" \
    
    
    //DIVISION
    @"^FO5,150" \
    @"^GB820,1,1,B,0^FS^XZ",
    currenRecibo.rVendedor,
    currenRecibo.rNoRecibo,
    currenRecibo.rVendedor,
    currenCliente.cVendedor,
    currenCliente.cTelefono1,
    currenCliente.cCodigo,
    currenRecibo.rNombreCliente,
    currenCliente.cDireccion,
    [conDB formatoFechaHoraEnglish:currenRecibo.rFecha]];
    
    [[printer getToolsUtil] sendCommand:header2 error:&error];
    
    NSString *headerDetalle = [NSString stringWithFormat:
    @"^XA^POI^LL80" \
    
    @"^FO5,0" \
    @"^A0,21,17" \
    @"^FDFACTURA^FS" \
    
    @"^FO200,0" \
    @"^A0,21,17" \
    @"^FDTIPO PAGO ^FS" \
    
    @"^FO430,0" \
    @"^A0,21,17" \
    @"^FDDOCUMENTO ^FS" \
    
    //SEGUNDA LINEA
    
    @"^FO5,20" \
    @"^A0,21,17" \
    @"^FDMONTO DOC^FS" \
    
    @"^FO200,20" \
    @"^A0,21,17" \
    @"^FDDESCUENTO ^FS" \
    
    @"^FO430,20" \
    @"^A0,21,17" \
    @"^FDMONTO PAGO ^FS" \
    
    //TERCERA LINEA
    
    @"^FO5,40" \
    @"^A0,21,17" \
    @"^FDBANCO^FS" \
    
    @"^FO200,40" \
    @"^A0,21,17" \
    @"^FDFECHA ^FS" \
    
    //@"^FO430,10" \
    @"^A0,21,17" \
    @"^FDDOCUMENTO ^FS" \
    
    
    //DIVISION
    @"^FO5,60" \
    @"^GB820,1,1,B,0^FS^XZ"];
    
    [[printer getToolsUtil] sendCommand:headerDetalle error:&error];
    
    
    
    float TotalCobrado = 0.00;
    float TotalDocumento = 0.00;
    float TotalDescuento = 0.00;
    float TotalNotaCredito = 0.00;
    
    int count = 0;
    for (int i = 0; i < datosDetalleArray.count; i++) {
        
        RecibosDetalles *currenDetalle = [datosDetalleArray objectAtIndex:i];
        
        
        NSString *lineItem =
            @"^XA^POI^LL70" \
        
        @"^FO5,10"\
        @"^ACN"\
        @"^FD%@^FS"\
        
        @"^FO200,10"\
        @"^A0,19,18"\
        @"^FD%@^FS" \
        
        @"^FO430,10"\
        @"^ACN"\
        @"^FD%@^FS" \
        
        //SEGUNDA LINEA
        @"^FO5,30"\
        @"^ACN"\
        @"^FD$%@^FS"\
        
        @"^FO200,30"\
        @"^ACN"\
        @"^FD%@^FS" \
        
        @"^FO430,30"\
        @"^ACN"\
        @"^FD$%@^FS" \
        
        //TERCERA LINEA
        @"^FO5,50"\
        @"^A0,19,18"\
        @"^FD%@^FS"\
        
        @"^FO200,50"\
        @"^A0,19,18"\
        @"^FD%@^FS" \
        
        //@"^FO430,30"\
        @"^A0,19,17"\
        @"^FD10,430.86^FS" \
        
        
        @"^XZ";
        
        
        float montoNeto = 0.00;
        float descuentoEnMonto = 0.00;
        NSString *TipoPago = @"-";
        NSString *descuentoStr = @"";
        NSString *Banco = @"";
        NSString *NoDocumento =@"";
        NSString *descuentoEnMontoStr= @"";
        
        Banco = [currenRecibo.rNombreBanco isEqualToString:@""] ? @"-" : currenRecibo.rNombreBanco;
        
        
        if ([currenDetalle.rdTipoDocumento isEqualToString:@"F"]) {
            
            TotalCobrado += [currenDetalle.rdTotalCobroDocumento floatValue];
            TotalDocumento += [currenDetalle.rdTotalDocumento floatValue];
            
            if ([dataUser getImpuestoSW]) {
                
                montoNeto = ([currenDetalle.rdTotalDocumento floatValue] -[currenDetalle.rdItbisDocumento floatValue]); //Monto Menos itbis
            }else{
                montoNeto = [currenDetalle.rdTotalDocumento floatValue];
            }
            
            descuentoEnMonto =  (montoNeto * ([currenDetalle.rdDescuento floatValue]/100.00));
            TotalDescuento += descuentoEnMonto;
            
            if ([currenRecibo.rCKFuturista intValue]== 1 ) {
                TipoPago = [[NSString alloc]initWithFormat:@"CK FUT.(%@)", [conDB formatoFechaEnglish:currenRecibo.rFechaFuturista]];
            }else{
                TipoPago = currenRecibo.rTipoPago;
            }
            
            descuentoEnMontoStr = [[NSString alloc] initWithFormat:@"%0.2f",descuentoEnMonto];
            NoDocumento = currenRecibo.rNoReferencia;
            
            
        }else if([currenDetalle.rdTipoDocumento isEqualToString:@"NC"] || [currenDetalle.rdTipoDocumento isEqualToString:@"nc"] ){
            
            TotalCobrado = TotalCobrado - [currenDetalle.rdTotalDocumento floatValue];
            TotalNotaCredito += [currenDetalle.rdTotalDocumento floatValue];
            descuentoEnMontoStr = @"0.00";
        }
        
        descuentoStr = [[NSString alloc] initWithFormat:@"-%@ (%@%@)",[conDB formatoNumero:descuentoEnMontoStr], currenDetalle.rdDescuento, @"%" ];
        
        NSString *lineItemWithVars = [NSString stringWithFormat:lineItem,
        currenDetalle.rdNoDocumento,
        TipoPago,
        NoDocumento,
        [conDB formatoNumero:currenDetalle.rdTotalDocumento],
        descuentoStr,
        [conDB formatoNumero:currenDetalle.rdTotalCobroDocumento],
        Banco,
        [conDB formatoFechaHoraEnglish:currenRecibo.rFecha]
        ];
        
        [[printer getToolsUtil] sendCommand:lineItemWithVars error:&error];
        
        //Esta opción es para solicionar el problema del buffer de la impresora y continue con la impresión constante
        if (count > 3) {
            sleep(1);
            count = 0;
        }
        count = count + 1;
        
    }
    
    
    NSString *totales = [NSString stringWithFormat:
    @"^XA^POI^LL160" \
    
    //DIVISION
    @"^FO5,0" \
    @"^GB820,1,1,B,0^FS"\
    
    //TOTAL
    @"^FO5,20" \
    @"^^ACN" \
    @"^FDTOTAL:^FS" \
    
    @"^FO160,20" \
    @"^^ACN" \
    @"^FD$%@^FS" \
    
    //DESCUENTO
    @"^FO5,40" \
    @"^^ACN" \
    @"^FDDESCUENTO: ^FS" \
    
    @"^FO160,40" \
    @"^^ACN" \
    @"^FD$%@ ^FS" \
    
    //EFECTIVO
    //  @"^FO5,60" \
    @"^A0,21,17" \
    @"^FDEFECTIVO:^FS" \
    
    //   @"^FO160,60" \
    @"^A0,21,17" \
    @"^FD$10,323.02^FS" \
    
    //CHEQUE
    // @"^FO5,60" \
    @"^A0,21,17" \
    @"^FDCHEQUE: ^FS" \
    
    //@"^FO160,60" \
    @"^A0,21,17" \
    @"^FD$1,323.03 ^FS" \
    
    //NOTA CREDITO
    @"^FO5,60" \
    @"^ACN" \
    @"^FDNOTA CREDITO: ^FS" \
    
    @"^FO160,60" \
    @"^ACN" \
    @"^FD$%@ ^FS" \
    
    //COBRADO
    @"^FO5,80" \
    @"^ACN" \
    @"^FDCOBRADO: ^FS" \
    
    @"^FO160,80" \
    @"^ACN" \
    @"^FD$%@ ^FS" \
    
    
    //DIVISION
    @"^FO150,100" \
    @"^A0,22,17" \
    @"^FD******FIN DEL COBRO****** ^FS^XZ",
    [conDB formatoNumero:[[NSString alloc]initWithFormat:@"%f", TotalDocumento]],
    [conDB formatoNumero:[[NSString alloc]initWithFormat:@"%f", TotalDescuento]],
    [conDB formatoNumero:[[NSString alloc]initWithFormat:@"%f", TotalNotaCredito]],
    [conDB formatoNumero:[[NSString alloc]initWithFormat:@"%f", [currenRecibo.rTotalCobro floatValue] ]]];
    
    [[printer getToolsUtil] sendCommand:totales error:&error];
    
    //@"^XA^POI^LL390^CI28"
    NSString *footer = [NSString stringWithFormat:
    
    @"^XA^POI^LL390" \
    
    //DIVISION
    @"^FO90,210" \
    @"^GB390,1,1,B,0^FS"\
    
    //FIrma
    @"^FO185,230" \
    @"^^ACN" \
    @"^FDFIRMA DEL VENDEDOR ^FS"\
    
    //Nota Final
    @"^FO10,280" \
    @"^FB480,4,,j"\
    @"^A0,16,14" \
    @"^FD%@ ^FS" \
    
    
    //FIrma SOFTWARE
    @"^FO160,310" \
    @"^A0,18,16" \
    @"^FDDevelop by: www.mobile-seller.com ^FS" \
    
    @"^XZ", datosEmpresa[@"pieRecibo"] ];
    
    
    
    [[printer getToolsUtil] sendCommand:footer error:&error];
    
    
    
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
*/