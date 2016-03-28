//
//  NearBeaconsScanner.h
//  ChimpNoise
//
//  Created by Andres Yepes on 3/23/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EstimoteSDK/EstimoteSDK.h>
#import "AYBeacon.h"

@interface NearBeaconsScanner : NSObject  <ESTBeaconManagerDelegate>

@property NSMutableArray *nearBeacons;
@property NSMutableDictionary *nearBeaconsDictionary;
-(AYBeacon *) next;
@end
