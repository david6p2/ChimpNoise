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
        self.isFavorite = NO;
    }
    return self;
}

-(instancetype) initWithBusinessName:(NSString *)businessName
                              beacon:(CLBeacon *)beacon
                      serverResponse:(NSDictionary *) responseObject{
    Card *new = [self init];
    if(responseObject[@"isFavorite"] && [responseObject[@"isFavorite"] isEqualToString:@"true"]){
        self.isFavorite = true;
    }
    self.dictionaryObject = responseObject;
    self.beacon           = beacon;
    self.cardId           = responseObject[@"_id"];
    self.businessName     = businessName;
    self.title            = businessName;
    self.key              = responseObject[@"beacon_code"];
    self.prompt           = responseObject[@"subject"];
    self.type             = responseObject[@"type"];
    
    self.imageURL         = responseObject[@"image"];
    self.message          = responseObject[@"message"];
    
    self.url              = responseObject[@"url"];
    self.urlTitle         = responseObject[@"urlDetail"][@"title"];
    self.urlDescription   = responseObject[@"urlDetail"][@"description"];
    self.urlImage         = responseObject[@"urlDetail"][@"image"];
    
    return new;
}

//Public
-(void) show{
    self.onScreen = YES;
}

-(void) hide{
    self.onScreen = NO;
}

-(NSDictionary *) toDictionary{
    NSMutableDictionary *cardDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.dictionaryObject];
    [cardDictionary setObject:self.businessName forKey:@"business_name"];
    [cardDictionary setObject:@"true" forKey:@"isFavorite"];
    return cardDictionary;
}

#pragma save Card
-(void) saveToFavorites{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    NSMutableArray *newFavorites = [NSMutableArray new];
    if (favorites != nil ){
        newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    }
    if (![self cardIsFavorite:newFavorites]) {
        [newFavorites addObject:[self toDictionary]];
    }
    [defaults setObject:newFavorites forKey:@"favorites"];
    self.isFavorite = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favoritesNotification" object:nil];
}

-(void) removeFromFavorites{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    if (favorites == nil) {
        return;
    }
    NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    for (NSDictionary* cardDictionary in newFavorites) {
        if ([cardDictionary[@"_id"] isEqualToString:self.cardId]) {
            [newFavorites removeObject:cardDictionary];
            [defaults setObject:newFavorites forKey:@"favorites"];
            self.isFavorite = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favoritesNotification" object:nil];
            return;
        }
    }
}

//Private
-(BOOL) cardIsFavorite:(NSArray *)favorites{
    for (NSDictionary* cardDictionary in favorites) {
        if ([self.cardId isEqualToString:cardDictionary[@"_id"]]) {
            return true;
        }
    }
    return false;
}
@end
