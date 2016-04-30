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
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                      target: self
                                                    selector:@selector(fetchBeaconsInRange)
                                                    userInfo: nil repeats:YES];
        NSTimer *m = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                      target: self
                                                    selector:@selector(cardsInRange)
                                                    userInfo: nil repeats:YES];
    }
    return self;
}

//public
-(Card *) cardToShowOnScreen{
    for (Card *card in self.cards) {
        if(card.onScreen){
            continue;
        }
        return card;
    }
    return nil;
}

-(NSArray *) cardsInRange{
    if([self.cards count] == 0){
        return nil;
    }
    
    NSLog(@"%@", [self.cards[0] description]);
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


@end
