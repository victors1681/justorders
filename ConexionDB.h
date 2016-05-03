//
//  ConexionDB.h
//  Clientes
//
//  Created by Victor on 01/05/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ConexionDB : NSObject
 

-(NSString *)formatoFecha:(NSString *)Fecha;
 -(NSString *)formatoNumero:(NSString *)Numero;
-(NSString *)formatoFechaHora:(NSString *)FechaHora;
-(NSString *)formatoFechaHoraEnglish:(NSString *)FechaHora;
-(NSString *)formatoFechaEnglish:(NSString *)Fecha;
-(NSString *)removerAcentos:(NSString *)string;

-(NSString *)formatoFechaToSql:(NSString *)Fecha;


@end
