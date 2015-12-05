//
//  CardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;
@protocol CardViewDelegate <NSObject>

-(void) cardViewUpdateTitle:(NSString *)title prompt:(NSString *)prompt;

@end


@interface CardView : UIView
@property (strong, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UIImageView * imageView;

//PROTOCOL - CardViewDelegate
@property (nonatomic, assign) id delegate;

-(void) cardSetup;

@end



