//
//  BeaconListener.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/29/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EstimoteSDK/EstimoteSDK.h>

#define BEACON_UUID_1 @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"
#define BEACON_UUID_2 @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19"
#define BEACON_UUID_3 @"67DED150-E522-17B6-CB70-843903F8644B"
#define BEACON_UUID_4 @"E5D4CCCB-57B9-45B9-89FE-BFACAE97D069"
#define BEACON_UUID_5 @"E20B8390-998A-444C-84E6-6CFC31636EA6"
#define BEACON_UUID_6 @"1B7F70DA-1B5D-4C16-A855-712DADDC3C1D"
#define BEACON_UUID_7 @"06DA99F3-9814-4FA2-9647-F4819683EA4A"
#define BEACON_UUID_8 @"51B34DEE-62DA-40E2-887E-E2A2F776FAF1"
#define BEACON_UUID_9 @"C45817A9-92F0-45AF-9BBC-A57DF26D2957"
#define BEACON_UUID_10 @"5F3899CE-6C15-4781-BFBE-D22BCAA196F6"
#define BEACON_UUID_11 @"6AABB393-8824-41D2-9841-A2F7DD3718B4"
#define BEACON_UUID_12 @"52FBD19A-BF3E-4CB5-A971-6C61AB277A34"
#define BEACON_UUID_13 @"55043A73-BB7B-42E4-ABD0-974F64CC00F6"
#define BEACON_UUID_14 @"6DDC0761-8F33-4FB5-9DB1-C71BD41DA717"
#define BEACON_UUID_15 @"E67BF08D-783F-4254-8791-A2DBA7825B7A"
#define BEACON_UUID_16 @"F9FA3232-5AC2-4113-BD1A-C9A689A09C69"
#define BEACON_UUID_17 @"4B701FB0-0AD9-41EF-B004-30596A54DBE0"
#define BEACON_UUID_18 @"798E32BA-475E-4D97-8E22-B345D8F4120F"
#define BEACON_UUID_19 @"B9260E0D-AF71-47C4-8B32-A441D9510D14"
#define BEACON_UUID_20 @"64BCC55E-6E86-4498-9CD8-B701F71EC119"

@interface BeaconListener : NSObject <ESTBeaconManagerDelegate>
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) NSArray *beacons;

+ (BeaconListener *) sharedInstance;

-(BOOL) verifyAuthorization;
-(void) requestAlwaysAuthorization;
-(void) startMonitoring;
-(void) startRanging;
-(void) stopRanging;

-(NSArray *) beaconsInRange;
    
@end
