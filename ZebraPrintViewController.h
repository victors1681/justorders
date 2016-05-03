//
//  ZebraPrintViewController.h
//  Clientes
//
//  Created by Victor Santos on 7/1/15.
//  Copyright (c) 2015 IT Soluclick. All rights reserved.
//

#import <ExternalAccessory/ExternalAccessory.h>
#import <UIKit/UIKit.h>

@interface ZebraPrintViewController : UIViewController


@property (weak,nonatomic) IBOutlet UILabel *statusLabel;
@property(nonatomic, strong) NSString *TipoImpresion; //Pedido - Cobro
@property(nonatomic, strong) NSString *NoDocumento;


@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;
@property(nonatomic)BOOL isBluetoothSelected;
@property (weak, nonatomic) IBOutlet UILabel *bluetoothPrinterLabel;


- (IBAction)chooseBluetoothButtonPressed:(id)sender;

-(void)setStatus: (NSString*)status withColor :(UIColor*)color;

@property (nonatomic, assign) BOOL performingDemo;

- (IBAction)imprimirDocumento:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imprimirButton;

- (IBAction)close:(id)sender;



@end
