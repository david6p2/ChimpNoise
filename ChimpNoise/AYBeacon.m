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
        
    }
    return self;
}

-(instancetype) initWithUUID:(NSString *) uuid minor:(NSNumber *) minor major:(NSNumber *) major{
    AYBeacon *new = [self init];
    new.uuid = uuid;
    new.minor = minor;
    new.major = major;
    return new;
}

@end
