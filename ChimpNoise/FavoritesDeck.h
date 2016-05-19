//
//  FavoritesDeck.h
//  ChimpNoise
//
//  Created by Andres Yepes on 5/19/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface FavoritesDeck : NSObject
+ (FavoritesDeck *) sharedInstance;
-(BOOL) add:(Card *)card;
-(BOOL) remove:(Card *) card;
-(BOOL) contains:(Card *) card;
-(NSArray *) favorites;
-(NSInteger) count;
@end
