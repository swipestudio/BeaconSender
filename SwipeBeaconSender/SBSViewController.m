//
//  SBSViewController.m
//  SwipeBeaconSender
//
//  Created by René Fouquet on 20.09.13.
//  Copyright (c) 2013 Swipe GmbH. All rights reserved.
//

#import "SBSViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SBSViewController ()

@end

@implementation SBSViewController

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    // The implementation of this delegate method is required, although we're not really doing anything with it
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // ! Make sure to enter your own unique UUID here. You can generate it using ´uuidgen´ in Terminal
    
    _uuidString = @"AA5FAED3-13C0-4CDB-91B0-F4BFA49C84C6";
    
    _onSwitch = [[UISwitch alloc] init];
    _onSwitch.center = self.view.center;
    _onSwitch.on=NO;
    [_onSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_onSwitch];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, _onSwitch.frame.origin.y-100, self.view.bounds.size.width-40, 20)];
    title.text=@"Swipe Beacon";
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:title];
    
    UILabel *activateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _onSwitch.frame.origin.y-30, self.view.bounds.size.width-40, 20)];
    activateLabel.text=@"Activate:";
    activateLabel.textAlignment=NSTextAlignmentCenter;
    activateLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:activateLabel];
    
    UILabel *uudidLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _onSwitch.frame.origin.y+50, self.view.bounds.size.width-40, 40)];
    uudidLabel.text=[NSString stringWithFormat:@"UUID: %@",_uuidString];
    uudidLabel.textAlignment=NSTextAlignmentCenter;
    uudidLabel.lineBreakMode=NSLineBreakByWordWrapping;
    uudidLabel.numberOfLines=2;
    uudidLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:uudidLabel];
    
    // Init CBPeripheralManager
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)viewDidDisappear:(BOOL)animated {
    // Stop the sender when the view disappears
    
    [_peripheralManager stopAdvertising];
    _onSwitch.on=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleSwitch:(id)sender {
    if (_onSwitch.on) {
        
        // Check if Bluetooth is activated. If not, alert the user, and exit the method.
        
        if(_peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
            [_onSwitch setOn:NO animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please activate Bluetooth" message:@"In order to use this device as a beacon, Bluetooth has to be activated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        // Set a CLBeaconRegion with the desired UUID and encode in peripheralData
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:_uuidString] identifier:@"com.swipe.beaconSender"];
        NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:[NSNumber numberWithInt:-56]];

        if (peripheralData) {
            [_peripheralManager startAdvertising:peripheralData];
        }
        
    } else {
        [_peripheralManager stopAdvertising];
    }
}
@end
