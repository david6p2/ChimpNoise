//
//  AYBeacon.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/28/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "AYBeacon.h"

@implementation AYBeacon

@synthesize delegate;

-(instancetype)init{
    if (self = [super init]) {
        self.title = nil;
        self.prompt = nil;
        self.imageURL = nil;
        self.onScreen = NO;
        self.firstTimeOnScreen = YES;
        self.fetchFromServer = NO;
        self.localNotification = NO;
        self.startDate = nil;
        self.endDate = nil;
    }
    return self;
}

-(instancetype) initWithUUID:(NSString *) uuid minor:(NSNumber *) minor major:(NSNumber *) major{
    AYBeacon *new = [self init];
    new.uuid = uuid;
    new.minor = minor;
    new.major = major;
    
    [new fetch];
    return new;
}

-(void) fetch{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://chimpnoise.com/api/noise/beacon/%@", [self key]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *noises = responseObject[@"noises"];
             for (NSDictionary *noise in noises) {
                 self.imageURL = noise[@"image"];
                 self.prompt = noise[@"subject"];
                 if ([noise[@"activity_time_type"] isEqualToString:@"minute"]) {
                     self.duration = [noise[@"activity_time_qty"] intValue] * 60;
                 }
                 self.fetchFromServer = YES;
                 
                 //Call Delegate to Update View
                 [delegate beaconUpdate];
             }
             NSLog(@"JSON: %@", responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

-(NSString *) key{
    return [NSString stringWithFormat:@"%@:%@:%@", self.uuid, self.major, self.minor];
}

-(void) display{
    self.onScreen = YES;
}
-(void) hide{
    self.onScreen = NO;
}

-(void) startCountdown{
    self.firstTimeOnScreen = NO;
    self.startDate = [NSDate date];
    self.endDate = [self.startDate dateByAddingTimeInterval:self.duration];
    NSLog(@"start: %@", self.startDate);
    NSLog(@"end: %@", self.endDate);
}
-(BOOL) expired{
    NSDate *now = [NSDate date];
    if([self.endDate compare: now] == NSOrderedAscending){
        return YES;
    }
    else{
        return NO;
    }
}
-(void) showNotification{
    self.localNotification = YES;
}

@end
