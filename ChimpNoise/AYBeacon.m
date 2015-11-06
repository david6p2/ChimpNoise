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
        self.demoPLaces = @{
                            @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D:1:1":@{
                                    @"title": @"Netshoes",
                                    @"prompt": @"Promotion 20% shoes",
                                    @"image": @"http://image.dhgate.com/albu_269291508_00/1.0x0.jpg"
                                    },
                            @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19:3:3":@{
                                    @"title": @"Iphone",
                                    @"prompt": @"50 USD off",
                                    @"image": @"http://www.sprint.com/landings/iphone-forever/images/iphone6s_lockup.jpg"
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
    new.onScreen = NO;
    
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

@end
