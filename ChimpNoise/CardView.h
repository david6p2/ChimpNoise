//
//  CardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;
@protocol AYCardViewDelegate <NSObject>

-(void) topCardViewUpdate;

@end

@interface CardView : UIView
@property (strong, nonatomic) NSString *cardTitle;
@property (strong, nonatomic) NSString *cardPrompt;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UIImageView * imageView;

//PROTOCOL - CardViewDelegate
@property (nonatomic, assign) id delegate;

-(void) cardSetup;

@end



