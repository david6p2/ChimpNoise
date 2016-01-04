//
//  AYBeacon.h
//  ChimpNoise
//
//  Created by Andres Yepes on 10/28/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"
#import <AFHTTPRequestOperationManager.h>

@class AYBeacon;
@protocol AYBeaconDelegate <NSObject>

-(void)beaconUpdate;

@end

@interface AYBeacon : NSObject <RMMapping>

@property (nonatomic, strong) NSString *uuid;
@property (retain) NSNumber *minor;
@property (retain) NSNumber *major;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *message;
@property BOOL onScreen;
@property BOOL firstTimeOnScreen;
@property BOOL fetchFromServer;
@property BOOL localNotification;
@property (nonatomic, strong) NSDate * startDate;
@property NSTimeInterval duration;
@property (nonatomic, strong) NSDate * endDate;

//PROTOCOL - AYBeaconDelegate
@property (nonatomic, assign) id delegate;

-(instancetype)initWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major;
-(void) display;
-(void) hide;
-(NSString *) key;

-(void) startCountdown;
-(BOOL) expired;
-(void) fetch;
-(void) showNotification;
@end
