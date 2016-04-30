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
    }
    return self;
}

//public
-(Card *) cardToShowOnScreen{
    if ([self.cards count] == 0) {
        return nil;
    }
    Card *card = self.cards[self.index];
    if (card.onScreen || [card.type isEqualToString:@"text"]) {
        [self next];
        return [self cardToShowOnScreen];
    }
    return card;
}

-(NSArray *) cardsInRange{
    if([self.cards count] == 0){
        return nil;
    }
    NSLog(@"cardsInRange: %li", [self.cards count]);
    return self.cards;
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://chimpnoise.com/api/noise/beacon/%@", key]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *noises = responseObject[@"noises"];
             for (NSDictionary *cardObject in noises) {
                 Card *newCard = [[Card alloc] initWithBusinessName:responseObject[@"business_name"]
                                                     serverResponse:cardObject];
                 [self.cards addObject:newCard];
             }
             [self.beaconsFetchedFromServer addObject:key];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"cardDeck.getCardsFromServerForBeacon.Error: %@", error);
         }];
}

-(NSString *)keyForBeacon:(CLBeacon *)beacon{
    return [NSString stringWithFormat:@"%@:%@:%@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor];
}

-(NSInteger) next{
    self.index++;
    if ([self.cards count] <= self.index) {
        self.index = 0;
    }
    return self.index;
}


@end
