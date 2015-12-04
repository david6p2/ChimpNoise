//
//  CardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "CardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon{
    self = [super initWithFrame:frame];
    if (self) {
        if(beacon){
            [self setupWithBeacon:beacon];
        }
        else{
            [self setup];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon{
    self = [super initWithCoder:aDecoder];
    if(beacon){
        [self setupWithBeacon:beacon];
    }
    else{
        [self setup];
    }
    return self;
}

- (void)setup {
    [self cardSetup];
    
    self.beacon = nil;
    
    [self addTitleLabel: @"Setup sin Beacon"];
    [self addImage: @"https://s-media-cache-ak0.pinimg.com/236x/20/a0/6a/20a06aed6797d0ffe0d6a524bd61cd1f.jpg"];
    [self addTimer];
}

- (void)setupWithBeacon:(AYBeacon *) beacon{
    [self cardSetup];
    
    self.beacon = beacon;
    beacon.delegate = self; //AYBeaconDelegate Protocol
    
    [self addImage: beacon.imageURL];
    [self addTimer];
}

-(void) addTitleLabel:(NSString *) title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/10)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 10.0f/12.0f;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}

-(void) addImage:(NSString *) imageUrlString{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 9/10);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: imageUrlString]
                 placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self addSubview:self.imageView];
}

-(void) addTimer{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 9/10,
                                                               self.frame.size.width,
                                                               self.frame.size.height * 1/10)];
    self.timeLabel.text = @"Loading";
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:10.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];
    self.timeLabel.backgroundColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.minimumScaleFactor = 10.0f/12.0f;
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
}

- (void)updateTimer{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate: self.beacon.startDate];
    
    //300 seconds count down
    NSTimeInterval timeIntervalCountDown = self.beacon.duration - timeInterval;
    if (timeIntervalCountDown < 0) {
        [self stopTimer];
        self.timeLabel.text = @"Ended";
    }
    else{
        if (timeIntervalCountDown < 40) {
            self.timeLabel.backgroundColor = [UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1.0];
            self.timeLabel.textColor = [UIColor whiteColor];
        }
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeIntervalCountDown];
        
        // Create a date formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        
        // Format the elapsed time and set it to the label
        NSString *timeString = [dateFormatter stringFromDate:timerDate];
        self.timeLabel.text = [NSString stringWithFormat:@"Ends in %@", timeString];
    }
}

- (void)stopTimer{
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
}


-(void) cardSetup{
    
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 0;
    
    // Card Setup
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - AYBeaconDelegate
-(void)beaconUpdate{
    
    [[AYChimpnoise sharedInstance] saveModel];

    if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateBackground) {
        if (self.beacon.localNotification == NO) {
            UILocalNotification *notification = [UILocalNotification new];
            notification.alertTitle = @"Chimpnoise";
            notification.alertBody = self.beacon.prompt;
            notification.alertAction = @"See Noise";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            [self.beacon showNotification];
        }
    }
    else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString: self.beacon.imageURL]];
        [self.beacon startCountdown];
        [self addTimer];
    }
}

@end

