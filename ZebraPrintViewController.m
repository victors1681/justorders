//
//  ViewController.m
//  test
//
//  Created by Victor Santos on 6/26/15.
//  Copyright (c) 2015 Victor Santos. All rights reserved.
//

#import "ZebraPrintViewController.h"

#import "TcpPrinterConnection.h"
#import "MfiBtPrinterConnection.h"
#import "BluetoothPrinterViewController.h"
#import "ZebraPrinterConnection.h"
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"

#import "FormatosZebra.h"
#import "UserDefault.h"

@interface ZebraPrintViewController ()

@end

@implementation ZebraPrintViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
   
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.isBluetoothSelected = YES;
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 134);
    
    
    [self performSelectorOnMainThread:@selector(bluetoothPrinterSelected:) withObject:nil waitUntilDone:0];
    
  
    
    //  return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)close:(id)sender{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}


- (void) bluetoothPrinterSelected:(NSNotification *) notification
{
     UserDefault *config = [[UserDefault alloc]init];
    
    if (self.bluetoothPrinterLabel.text == nil) {
        
        self.bluetoothPrinterLabel.text = @"Utilize el botón de configurar impresora";
        
    }else{
        
        self.bluetoothPrinterLabel.text = [config getZebraImpresora];
    }
    
    
}



-(void)changeStatusLabel: (NSArray*)statusInfo {
    NSString *statusText = [statusInfo objectAtIndex:0];
    UIColor *statusColor = [statusInfo objectAtIndex:1];
    
    NSString *tmpStatus = [NSString stringWithFormat:@"Status : %@", statusText];
    [self.statusLabel setText:tmpStatus];
    [self.statusLabel setBackgroundColor:statusColor];
}




- (IBAction)chooseBluetoothButtonPressed:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(IBAction)unwindBlue:(UIStoryboardSegue *)sender
{
   [self performSelectorOnMainThread:@selector(bluetoothPrinterSelected:) withObject:nil waitUntilDone:0];
  
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}





- (IBAction)imprimirDocumento:(id)sender {
    
   
    self.imprimirButton.enabled = false;
    
    //[NSThread detachNewThreadSelector:@selector(performReceiptPrinting:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
    [self performSelectorInBackground:@selector(performReceiptPrinting:) withObject:[NSNumber numberWithBool:YES]];
}


- (void) performReceiptPrinting: (NSNumber*)printAsManyJobs {
    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    BOOL isPrintFinish = false;
    
    FormatosZebra *formatoRecibo = [[FormatosZebra alloc]init];
    @autoreleasepool{
        
        self.performingDemo = YES;
        
        [self setStatus:@"Connecting..." withColor:[UIColor yellowColor]];
        id<ZebraPrinterConnection, NSObject> connection = nil;
        
        if(self.isBluetoothSelected) {
            connection = [[MfiBtPrinterConnection alloc] initWithSerialNumber:self.bluetoothPrinterLabel.text] ;
        }
        
        BOOL didOpen = [connection open];
        if(didOpen == YES) {
            [self setStatus:@"Conectando..." withColor:[UIColor greenColor]];
            [self setStatus:@"Determinando el lenguaje del Printer..." withColor:[UIColor yellowColor]];
            
            NSError *error = nil;
            id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
            
            if(printer != nil) {
                PrinterLanguage language = [printer getPrinterControlLanguage];
                [self setStatus:[NSString stringWithFormat:@"Lenguaje: %@",[self getLanguageName:language]] withColor:[UIColor cyanColor]];
                if(language == PRINTER_LANGUAGE_CPCL) {
                    [self setStatus:@"Esta aplicación no trabaja con printer CPCL!" withColor:[UIColor redColor]];
                } else {
                    [self setStatus:@"Generando documento en ZPL..." withColor:[UIColor cyanColor]];
                    
                    if(printAsManyJobs.boolValue) {
                        [self setStatus:@"Enviando los datos al printer" withColor:[UIColor cyanColor]];
                        
                        //Validar el tipo de impresión
                           
                          isPrintFinish = [formatoRecibo printPedidosZebra:printer andNoDocumento:self.NoDocumento];
                            
                          
                            
                    } else {
                        [self setStatus:@"Enviando los datos al printer" withColor:[UIColor cyanColor]];
                        
                       
                    }
                }
                
            } else {
                [self setStatus:@"No se pudo detectar el lenguaje del printer" withColor:[UIColor redColor]];
            }
            
            
        } else {
            [self setStatus:@"No me peuedo comunicar con el printer" withColor:[UIColor redColor]];
        }
        
        
        //if (isPrintFinish) {
            
            [self setStatus:@"Desconectando..." withColor:[UIColor redColor]];
            [connection close];
            self.performingDemo = NO;
            [self setStatus:@"Printer desconectado" withColor:[UIColor redColor]];
            self.imprimirButton.enabled = true;
        //}
    }
    
}

-(void)setStatus: (NSString*)status withColor :(UIColor*)color {
    NSArray *statusInfo = [NSArray arrayWithObjects:status, color, nil];
    [self performSelectorOnMainThread:@selector(changeStatusLabel:) withObject:statusInfo waitUntilDone:NO];
    [NSThread sleepForTimeInterval:1];
}




-(NSString*) getLanguageName :(PrinterLanguage)language {
    if(language == PRINTER_LANGUAGE_ZPL){
        return @"ZPL";
    } else {
        return @"CPCL";
    }
}


 
@end
