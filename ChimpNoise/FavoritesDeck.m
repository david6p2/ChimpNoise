//
//  FavoritesDeck.m
//  ChimpNoise
//
//  Created by Andres Yepes on 5/19/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "FavoritesDeck.h"

@implementation FavoritesDeck

static FavoritesDeck *sharedInstance = nil;

#pragma mark - singleton
+ (FavoritesDeck *) sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[FavoritesDeck alloc] init];
        }
        return(sharedInstance);
    }
}

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addFromNotification:)
                                                     name:@"addCardToFavorites"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeFromNotification:)
                                                     name:@"removeCardToFavorites"
                                                   object:nil];
    }
    return self;
}

-(BOOL) add:(Card *)card{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    NSMutableArray *newFavorites = [NSMutableArray new];
    if (favorites != nil ){
        newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    }
    if (![self contains:card]) {
        [newFavorites addObject:[card toDictionary]];
    }
    [defaults setObject:newFavorites forKey:@"favorites"];
    card.isFavorite = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favoritesNotification" object:nil];
    return true;
}

-(BOOL) remove:(Card *) card{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    if (favorites == nil) {
        return false;
    }
    NSMutableArray *newFavorites = [[NSMutableArray alloc] initWithArray:favorites];
    for (NSDictionary* cardDictionary in newFavorites) {
        if ([cardDictionary[@"_id"] isEqualToString:card.cardId]) {
            [newFavorites removeObject:cardDictionary];
            [defaults setObject:newFavorites forKey:@"favorites"];
            card.isFavorite = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favoritesNotification" object:nil];
            return true;
        }
    }
    return false;
}

-(BOOL) contains:(Card *) card{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    if (favorites == nil) {
        return false;
    }
    for (NSDictionary* cardDictionary in favorites) {
        if ([card.cardId isEqualToString:cardDictionary[@"_id"]]) {
            return true;
        }
    }
    return false;
}

-(NSArray *)favorites{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *cardDictionary in favorites) {
        [array addObject:[[Card alloc] initWithBusinessName:cardDictionary[@"business_name"]
                                                     beacon:nil
                                             serverResponse:cardDictionary]];
    }
    return array;
}

-(NSInteger) count{
    return [[self favorites] count];
}

#pragma mark - Notifications Handler
-(void) addFromNotification:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[Card class]])
    {
        Card *card = [notification object];
        [self add:card];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void) removeFromNotification:(NSNotification *) notification{
    if ([notification.object isKindOfClass:[Card class]])
    {
        Card *card = [notification object];
        [self remove:card];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}
@end
