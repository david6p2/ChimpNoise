//
//  Card.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/30/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *urlTitle;
@property (nonatomic, strong) NSString *urlDescription;
@property (nonatomic, strong) NSString *urlImage;
@property BOOL onScreen;

-(instancetype) initWithBusinessName:(NSString *)businessName serverResponse:(NSDictionary *) responseObject;

-(void) show;
-(void) hide;
@end
