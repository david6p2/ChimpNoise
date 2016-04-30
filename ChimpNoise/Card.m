//
//  Card.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/30/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "Card.h"

@implementation Card
-(instancetype)init{
    if (self = [super init]) {
        self.onScreen = NO;
    }
    return self;
}

-(instancetype) initWithBusinessName:(NSString *)businessName serverResponse:(NSDictionary *) responseObject{
    Card *new = [self init];
    self.businessName   = businessName;
    self.title          = businessName;
    self.key            = responseObject[@"beacon_code"];
    self.prompt         = responseObject[@"subject"];
    self.type           = responseObject[@"type"];
    
    self.imageURL       = responseObject[@"image"];
    self.message        = responseObject[@"message"];
    
    self.url            = responseObject[@"url"];
    self.urlTitle       = responseObject[@"urlDetail"][@"title"];
    self.urlDescription = responseObject[@"urlDetail"][@"description"];
    self.urlImage       = responseObject[@"urlDetail"][@"image"];
    
    return new;
}

-(void) show{
    self.onScreen = YES;
}

-(void) hide{
    self.onScreen = NO;
}
@end
