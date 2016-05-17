//
//  CardDeck.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/29/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconListener.h"
#import <AFHTTPRequestOperationManager.h>
#import "Card.h"

@interface CardDeck : NSObject

@property (nonatomic, strong) BeaconListener* beaconListener;
@property (nonatomic, strong) NSMutableArray* cards;
@property (nonatomic, strong) NSMutableArray* beaconsFetchedFromServer;
@property NSInteger index;

+ (CardDeck *) sharedInstance;
- (NSArray *) cardsInRange;
    
@end
