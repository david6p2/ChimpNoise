//
//  Card.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/30/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EstimoteSDK/EstimoteSDK.h>


@interface Card : NSObject

@property (nonatomic, strong) CLBeacon *beacon;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSString *beaconName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *urlTitle;
@property (nonatomic, strong) NSString *urlDescription;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSDictionary *dictionaryObject;
@property BOOL onScreen;
@property BOOL isFavorite;

-(instancetype) initWithBusinessName:(NSString *)businessName
                              beacon:(CLBeacon *)beacon
                      serverResponse:(NSDictionary *) responseObject;

-(void) show;
-(void) hide;
-(void) saveToFavorites;
-(void) removeFromFavorites;
-(NSDictionary *) toDictionary;
@end
