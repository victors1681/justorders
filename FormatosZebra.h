//
//  ReciboViewController.h
//  test
//
//  Created by Victor Santos on 6/26/15.
//  Copyright (c) 2015 Victor Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ViewController.h"
#import <UIKit/UIKit.h>

#import "ZebraPrinterConnection.h"
#import "TcpPrinterConnection.h"
#import "MFiBtPrinterConnection.h"
#import "ZebraPrinterFactory.h"

@interface FormatosZebra : NSObject

@property (nonatomic, assign) BOOL performingDemo;

@property (retain, nonatomic) NSArray *itemsToPrint;
@property (retain, nonatomic) NSString *status;

-(BOOL)printPedidosZebra:(id<NSObject,ZebraPrinter>)printer andNoDocumento:(NSString *)NoDocumento;

@end
