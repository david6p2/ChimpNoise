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
        self.title = @"";
        self.prompt = @"loading..";
        self.imageURL = nil;
        self.onScreen = NO;
        self.firstTimeOnScreen = YES;
        self.fetchFromServer = NO;
        self.localNotification = NO;
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
             [self handleFetchSuccess: responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    NSLog(@"AYBeacon.fetch");
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

-(void) showNotification{
    self.localNotification = YES;
}

-(void) handleFetchSuccess:(id) responseObject{
    NSArray *noises = responseObject[@"noises"];
    self.businessName = responseObject[@"business_name"];
    self.title        = self.businessName;
    
    for (NSDictionary *noise in noises) {
        self.prompt   = noise[@"subject"];
        self.type     = noise[@"type"];
        
        self.imageURL = noise[@"image"];
        self.message  = noise[@"message"];
        
        self.url      = noise[@"url"];
        self.urlTitle = noise[@"urlDetail"][@"title"];
        self.urlDescription = noise[@"urlDetail"][@"description"];
        self.urlImage = noise[@"urlDetail"][@"image"];

        self.fetchFromServer = YES;
        
        //Call Delegate to Update View
        [delegate beaconUpdate];
    }
    NSLog(@"AYBeacon.handleFetchSuccess");
}

@end
