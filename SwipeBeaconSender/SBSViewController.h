//
//  SBSViewController.h
//  SwipeBeaconSender
//
//  Created by René Fouquet on 20.09.13.
//  Copyright (c) 2013 Swipe GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SBSViewController : UIViewController <CBPeripheralManagerDelegate,UIAlertViewDelegate> {
    CBPeripheralManager *_peripheralManager;
    UISwitch *_onSwitch;
    NSString *_uuidString;
}

- (void)toggleSwitch:(id)sender;

@end
