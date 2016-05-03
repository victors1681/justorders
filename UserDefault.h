//
//  UserDefault.h
//  Clientes
//
//  Created by Victor on 04/05/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSUserDefaults

-(void)setZebraImpresora:(NSString *)nombre;
-(NSString *)getZebraImpresora;

@end
