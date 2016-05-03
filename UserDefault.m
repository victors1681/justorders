//
//  UserDefault.m
//  Clientes
//
//  Created by Victor on 04/05/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "UserDefault.h" 

@implementation UserDefault


-(void)setZebraImpresora:(NSString *)nombre
{
    NSUserDefaults *AA = [NSUserDefaults standardUserDefaults] ;
    [AA setObject:nombre forKey:@"impresoraBT"];
    [AA synchronize];
    
}

-(NSString *)getZebraImpresora
{
    
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    
    NSString *impresora = [dataUser stringForKey:@"impresoraBT"];
    
    return impresora;
}

@end
