//
//  AYBeacon.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/28/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "AYBeacon.h"

@implementation AYBeacon

-(instancetype)init{
    if (self = [super init]) {
        self.title = nil;
        self.prompt = nil;
        self.imageURL = nil;
        self.onScreen = NO;
        self.firstTimeOnScreen = YES;
        self.startDate = nil;
        self.endDate = nil;
        self.demoPLaces = @{
                            @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D:1:1":@{
                                    @"title": @"DRONE EXPO",
                                    @"prompt": @"Come fly with us!",
                                    @"image": @"http://www.lacoliseum.com/wp-content/uploads/2014/10/UAVSA-Drone-Expo-FLYER.jpg",
                                    @"duration": @600
                                    },
                            @"67DED150-E522-17B6-CB70-843903F8644B:2:2":@{
                                    @"title": @"Porsche",
                                    @"prompt": @"1992 - 968 Series",
                                    @"image": @"http://www.vintageautolit.com/images/1992_porsche_.jpg",
                                    @"duration": @1200
                                    },
                            @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19:3:3":@{
                                    @"title": @"COFFEE NIGHT",
                                    @"prompt": @"Monday August 19th  at Eco Mini Park",
                                    @"image": @"http://www.onlinedesigny.com/wp-content/uploads/2014/10/12-Coffee-Shop-Special-Invite-Flyer.png",
                                    @"duration": @60
                                    }
                            };
        
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

-(bool) fetch{
    NSDictionary * response = [self.demoPLaces objectForKey:[self key]];
    if(response == nil){
        return false;
    }
    else{
        self.title = [response objectForKey:@"title"];
        self.prompt = [response objectForKey:@"prompt"];
        self.imageURL = [response objectForKey:@"image"];
        NSNumber *dur = (NSNumber *)[response objectForKey:@"duration"];
        self.duration = [dur intValue];
    }
    return true;
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

@end
