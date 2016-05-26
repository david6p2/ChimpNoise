//
//  CardDeck.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/29/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "CardDeck.h"

@implementation CardDeck

static CardDeck *sharedInstance = nil;

#pragma mark - singleton
+ (CardDeck *) sharedInstance{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[CardDeck alloc] init];
        }
        return(sharedInstance);
    }
}

-(instancetype)init{
    if (self = [super init]) {
        self.beaconListener = [BeaconListener sharedInstance];
        self.cards = [[NSMutableArray alloc] init];
        self.beaconsFetchedFromServer = [[NSMutableArray alloc] init];
        self.index = 0;
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2
                                                      target: self
                                                    selector:@selector(fetchBeaconsInRange)
                                                    userInfo: nil repeats:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exitRegion:)
                                                     name:@"exitRegion"
                                                   object:nil];
    }
    return self;
}

//public
-(NSArray *) cardsInRange{
    if([self.cards count] == 0){
        return nil;
    }
    NSLog(@"cardsInRange: %li", [self.cards count]);
    return self.cards;
}

-(void) hideAll{
    for (Card *card in self.cards) {
        [card hide];
    }
}

//private
-(void) fetchBeaconsInRange{
    NSArray *beacons = [self.beaconListener beaconsInRange];
    for (CLBeacon *beacon in beacons) {
        [self getCardsFromServerForBeacon: beacon];
    }
}

-(void) getCardsFromServerForBeacon:(CLBeacon *)beacon{
    NSString *key = [self keyForBeacon:beacon];
    if ([self.beaconsFetchedFromServer containsObject:key]) {
        return;
    }
    [self.beaconsFetchedFromServer addObject:key];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://chimpnoise.com/api/noise/beacon/%@", key]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *noises = responseObject[@"noises"];
             for (NSDictionary *cardObject in noises) {
                 Card *newCard = [[Card alloc] initWithBusinessName:responseObject[@"business_name"]
                                                             beacon: beacon
                                                     serverResponse:cardObject];
                 [self.cards addObject:newCard];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"cardDeck.getCardsFromServerForBeacon.Error: %@", error);
             [self.beaconsFetchedFromServer removeObject:key];
         }];
}

-(NSString *)keyForBeacon:(CLBeacon *)beacon{
    return [NSString stringWithFormat:@"%@:%@:%@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor];
}

#pragma mark - Notifications
-(void) exitRegion:(NSNotification *)notification{
    NSLog(@"exitRegion");
    NSString *uuid = [[notification userInfo] objectForKey:@"uuid"];
    NSMutableArray *newCardsArray = [NSMutableArray new];
    for (Card *card in self.cards) {
        if ([[card.beacon.proximityUUID UUIDString] isEqualToString:uuid]) {
            continue;
        }
        [newCardsArray addObject:card];
    }
    self.cards = newCardsArray;
}
@end
