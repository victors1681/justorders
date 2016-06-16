//
//  ConexionDB.m
//  Clientes
//
//  Created by Victor on 01/05/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "ConexionDB.h"


@implementation ConexionDB

 
-(NSString *)formatoFechaHoraCorto:(NSString *)FechaHora
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: FechaHora];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSString *convertedString = [dateFormatter stringFromDate:date];
    // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}


-(NSString *)formatoFechaHora:(NSString *)FechaHora
{
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: FechaHora];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy hh:mm a"];
    NSString *convertedString = [dateFormatter stringFromDate:date];
   // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}


-(NSString *)formatoFecha:(NSString *)Fecha
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString: Fecha];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
   // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}

-(NSString *)formatoFechaEnglish:(NSString *)Fecha
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString: Fecha];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
   // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}

-(NSString *)formatoFechaToSql:(NSString *)Fecha
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    NSDate *date = [dateFormatter dateFromString: Fecha];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
   // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}

-(NSString *)formatoFechaHoraEnglish:(NSString *)FechaHora
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: FechaHora];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy hh:mm a"];
    NSString *convertedString = [dateFormatter stringFromDate:date];
   // NSLog(@"Converted String : %@",convertedString);
    
    return convertedString;
}


-(NSString *)formatoNumero:(NSString *)NumeroNew
{
    
    if ([NumeroNew isEqual:[NSNull null]]) {
        NumeroNew = @"0";
    }
    
    //Redondear
    NSString *Numero = [[NSString alloc] initWithFormat:@"%.2f", [NumeroNew doubleValue]];
    
    NSString *TotalFormato =0;
    
    if(![Numero isEqual:[NSNull null]]){
        NSNumber *totol = [[NSNumber alloc] initWithDouble:[Numero doubleValue]];
    
       TotalFormato = [NSNumberFormatter localizedStringFromNumber:totol
                                                              numberStyle:NSNumberFormatterDecimalStyle];
    }
    return TotalFormato;
}


-(NSString *)FormatNumberCurrency:(NSString *)NumeroNew
{
    
    //NSString *localizedString = [NSString localizedStringWithFormat:@"%3.2f", testNumber];
    //NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    if ([currencySymbol isEqualToString:@"DOP"]) {
        currencySymbol = @"RD$";
    }
    
   // NSString *language2 = [locale displayNameForKey:NSLocaleIdentifier

    
    if ([NumeroNew isEqual:[NSNull null]]) {
        NumeroNew = @"0";
    }
    
    //Redondear
    NSString *Numero = [[NSString alloc] initWithFormat:@"%.2f", [NumeroNew doubleValue]];
    
    NSString *TotalFormato =0;
    
    if(![Numero isEqual:[NSNull null]]){
        NSNumber *totol = [[NSNumber alloc] initWithDouble:[Numero doubleValue]];
        
        TotalFormato = [NSNumberFormatter localizedStringFromNumber:totol
                                                        numberStyle:NSNumberFormatterDecimalStyle];
    }
    return [[NSString alloc]initWithFormat:@"%@%@", currencySymbol,TotalFormato];
}

-(NSInteger)getDaysFromDate:(NSString *)date
{
    NSDateComponents *components;
    
    NSString *str = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFactura = [formatter dateFromString:str];
    
    
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                 fromDate:dateFactura  toDate: [NSDate date] options: 0];
    return [components day];
    
}



@end
