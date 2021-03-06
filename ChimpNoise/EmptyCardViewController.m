//
//  EmptyCardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 5/5/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "EmptyCardViewController.h"

@interface EmptyCardViewController ()

@end

@implementation EmptyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self initPulse];
    [self.view setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initPulse{
    CGRect pulseFrame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
    self.pulseView = [[UIView alloc] initWithFrame: pulseFrame];
    self.pulseView.backgroundColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];
    self.pulseView.layer.cornerRadius = 50;
    self.pulseView.layer.shadowOffset = CGSizeMake(0, 0);
    self.pulseView.layer.shadowRadius = 2;
    self.pulseView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.pulseView.layer.shadowOpacity = 1;
    CGRect backgroundPulseFrame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
    self.backgroundPulseView = [[UIImageView alloc] initWithFrame: backgroundPulseFrame];
    self.backgroundPulseView.image = [UIImage imageNamed:@"pulseBackground.png"];
    
    [self.view addSubview:self.pulseView];
    [self.view addSubview:self.backgroundPulseView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    animation.removedOnCompletion = false;
    animation.fromValue = [NSNumber numberWithFloat:1.4];
    animation.toValue = [NSNumber numberWithFloat:2];
    
    [self.pulseView.layer addAnimation:animation forKey:@"scale"];
}
@end
