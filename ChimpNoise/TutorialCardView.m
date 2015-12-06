//
//  TutorialCardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 12/4/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "TutorialCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TutorialCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self cardSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                          key:(NSString *)key
                     delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.key = key;
        self.delegate = delegate;
        self.cardTitle = @"Tutorial";
        if([key isEqualToString:@"swipeRightTutorial"]){
            self.cardPrompt = @"Step 1 of 2";
        }
        else{
            self.cardPrompt = @"Step 2 of 2";
        }
        
        [self cardSetup];
        [self addImage: key];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
                          key:(NSString *)key
                     delegate:(id)delegate{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.key = key;
        self.delegate = delegate;
        [self cardSetup];
        [self addImage: key];
    }
    return self;
}

-(void) addImage:(NSString *) imageUrlString{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 10/10);
    self.imageView.image = [UIImage imageNamed:imageUrlString];
    [self addSubview:self.imageView];
}
@end
