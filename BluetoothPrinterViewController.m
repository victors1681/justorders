//
//  BluetoothPrinterViewController.m
//  test
//
//  Created by Victor Santos on 6/26/15.
//  Copyright (c) 2015 Victor Santos. All rights reserved.
//

#import "BluetoothPrinterViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "UserDefault.h"

@interface BluetoothPrinterViewController ()

@end

@implementation BluetoothPrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAAccessoryManager *manager = [EAAccessoryManager sharedAccessoryManager];
    
    self.bluetoothPrinters = [[NSMutableArray alloc] initWithArray:manager.connectedAccessories] ;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bluetoothPrinters.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"If you do not see your printer here, you need to make sure it is configured in your iOS settings.   Go to Settings > Bluetooth and pair with your printer.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    EAAccessory *accessory = [self.bluetoothPrinters objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", accessory.name, accessory.serialNumber];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EAAccessory *accessory = [self.bluetoothPrinters objectAtIndex:indexPath.row];

    UserDefault *config = [[UserDefault alloc]init];
    [config setZebraImpresora:accessory.serialNumber];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
