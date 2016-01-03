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
        if(beacon){
            [self cardSetup];
            self.beacon = beacon;
            self.delegate = delegate;

            beacon.delegate = self; //AYBeaconDelegate Protocol
            self.cardTitle = self.beacon.title;
            self.cardPrompt = self.beacon.prompt;
            
            [self body];
            
            [self addTimer];
            if (self.beacon.fetchFromServer == YES) {
                [self startTimer];
            }
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon delegate:(id)delegate{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if(beacon){
            [self cardSetup];
            self.beacon = beacon;
            self.delegate = delegate;
            beacon.delegate = self; //AYBeaconDelegate Protocol
            
            self.cardTitle = self.beacon.title;
            self.cardPrompt = self.beacon.prompt;
            
            [self body];
            
            [self addTimer];
            if (self.beacon.fetchFromServer == YES) {
                [self startTimer];
            }

        }
    }
    return self;
}

- (void)body{
    NSLog(@"BeaconCardView- Implement body: to setup your CardView.");
}

#pragma mark - AYBeaconDelegate
-(void)beaconUpdate{
    NSLog(@"BeaconCardView- Implement beaconUpdate: to update AYBeacon attributes.");
}

#pragma mark - UIView Touch Events
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"BeaconCardView- Implement touchesEnded:withEvent: to setup touchesEnded event.");
}


#pragma mark - Timer
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
@end
