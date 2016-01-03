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
    [self setupContainedType];
}

-(void) setupContainedType{
    if (self.containedTypeView) {
        [self.containedTypeView removeFromSuperview];
        self.containedTypeView = nil;
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if(self.beacon.type == nil){
        self.containedTypeView = [self imageBeaconCardType:self.beacon frame:frame];
    }
    else if([self.beacon.type isEqualToString:@"url"]){
        self.containedTypeView = [self urlBeaconCardType:self.beacon frame:frame];
    }
    else if ([self.beacon.type isEqualToString:@"image"]){
        self.containedTypeView = [self imageBeaconCardType:self.beacon frame:frame];
    }
    [self addSubview: self.containedTypeView];
    
    [self addTimer];
    [self startTimer];
}

-(void) addTimer{
    if (self.timeLabel == nil) {
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
    }
    [self addSubview:self.timeLabel];
}

-(void) startTimer{
    if (self.beacon.fetchFromServer == YES) {
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:10.0/10.0
                                                               target:self
                                                             selector:@selector(updateTimer)
                                                             userInfo:nil
                                                              repeats:YES];
    }
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

#pragma mark - BeaconCardTypes
-(UIView *) urlBeaconCardType:(AYBeacon *)beacon frame:(CGRect)frame{
    UIView *container = [[UIView alloc]initWithFrame:frame];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,
                                 0,
                                 self.frame.size.width,
                                 self.frame.size.height * 33/100);
    [imageView sd_setImageWithURL:[NSURL URLWithString: beacon.imageURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [container addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                               self.frame.size.height * 36/100,
                                                               container.frame.size.width - 40,
                                                               self.frame.size.height * 11/100)];
    title.text = @"James tendría que pagar 50 mil euros en multas por incidente vial";
    title.font = [title.font fontWithSize:18];
//    title.backgroundColor = [UIColor grayColor];
    title.textColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];;
    title.numberOfLines = 2;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 10.0f/12.0f;
    title.clipsToBounds = YES;
    title.textAlignment = NSTextAlignmentLeft;
    [container addSubview:title];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     self.frame.size.height * 46/100,
                                                                     container.frame.size.width - 40,
                                                                     self.frame.size.height * 26/100)];
    description.text = @"El incidente de transito que protagonizó James Rodríguez el primer día de 2016 podría afectar la economía del colombiano.  Y es que según el diario ‘El Mundo’, de España, el ‘10’ tendría que pagar 50 mil euros sumando diferentes multas. \n\n www.futbolred.com";
    description.font = [description.font fontWithSize:15];
//    description.backgroundColor = [UIColor redColor];
    description.textColor = [UIColor grayColor];
    description.numberOfLines = 8;
    description.adjustsFontSizeToFitWidth = YES;
    description.minimumScaleFactor = 10.0f/12.0f;
    description.clipsToBounds = YES;
    description.textAlignment = NSTextAlignmentLeft;
    [container addSubview:description];
    
    UILabel *tapToLearnMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     self.frame.size.height * 91/100,
                                                                     container.frame.size.width - 40,
                                                                     self.frame.size.height * 9/100)];
    tapToLearnMoreLabel.text = @"Tap to learn more";
    tapToLearnMoreLabel.font = [tapToLearnMoreLabel.font fontWithSize:12];
//    tapToLearnMoreLabel.backgroundColor = [UIColor redColor];
    tapToLearnMoreLabel.textColor = [UIColor grayColor];
    tapToLearnMoreLabel.numberOfLines = 5;
    tapToLearnMoreLabel.adjustsFontSizeToFitWidth = YES;
    tapToLearnMoreLabel.minimumScaleFactor = 10.0f/12.0f;
    tapToLearnMoreLabel.clipsToBounds = YES;
    tapToLearnMoreLabel.textAlignment = NSTextAlignmentLeft;
    [container addSubview:tapToLearnMoreLabel];
    
    return container;
}

-(UIView *) imageBeaconCardType:(AYBeacon *)beacon frame:(CGRect)frame{
    UIView * container = [[UIView alloc]initWithFrame:frame];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 10/10);
    [imageView sd_setImageWithURL:[NSURL URLWithString: beacon.imageURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [container addSubview:imageView];

    return container;
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
        [self setupContainedType];
        [self.beacon startCountdown];
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
