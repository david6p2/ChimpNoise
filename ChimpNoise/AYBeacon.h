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

@interface AYBeacon : NSObject <RMMapping>

@property (nonatomic, strong) NSDictionary *demoPLaces;

@property (nonatomic, strong) NSString *uuid;
@property (retain) NSNumber *minor;
@property (retain) NSNumber *major;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *imageURL;
@property BOOL onScreen;
@property BOOL firstTimeOnScreen;
@property (strong, nonatomic) NSDate * startDate;
@property NSTimeInterval duration;
@property (strong, nonatomic) NSDate * endDate;


-(instancetype)initWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major;
-(void) display;
-(void) hide;
-(NSString *) key;

-(void) startCountdown;
-(BOOL) expired;
@end
