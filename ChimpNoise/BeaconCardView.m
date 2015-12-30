//
//  BeaconCardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 12/5/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "BeaconCardView.h"


@implementation BeaconCardView

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon delegate:(id)delegate{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (void)setupWithBeacon:(AYBeacon *) beacon{
    [self cardSetup];
    
    self.beacon = beacon;
    beacon.delegate = self; //AYBeaconDelegate Protocol
    self.cardTitle = self.beacon.title;
    self.cardPrompt = self.beacon.prompt;
    
    [self addImage: beacon.imageURL];
    [self addTimer];
    if (self.beacon.fetchFromServer == YES) {
        [self startTimer];
    }
}

-(void) addImage:(NSString *) imageUrlString{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 10/10);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: imageUrlString]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self addSubview:self.imageView];
}

-(void) addTimer{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 30,
                                                               self.frame.size.height * 8/10 + 39.5,
                                                               self.frame.size.width,
                                                               self.frame.size.height * 1.5/10)];
    self.timeLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    self.timeLabel.text = @"Loading";
    self.timeLabel.backgroundColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.numberOfLines = 2;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.minimumScaleFactor = 10.0f/12.0f;
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
}

-(void) startTimer{
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:10.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];
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
        self.timeLabel.text = [NSString stringWithFormat:@"Ends in\n %@", timeString];
    }
}

- (void)stopTimer{
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
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
        [self startTimer];
        self.cardTitle = self.beacon.prompt;
        self.cardPrompt = self.beacon.title;
        [self.delegate topCardViewUpdate];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.beacon.type isEqualToString:@"url"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.beacon.url]];
    }
}


@end
