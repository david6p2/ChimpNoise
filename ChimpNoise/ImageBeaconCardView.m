//
//  ImageBeaconCardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 12/30/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "ImageBeaconCardView.h"

@implementation ImageBeaconCardView

- (void)body{
    [self addImage: self.beacon.imageURL];
}

#pragma mark - Body
-(void) addImage:(NSString *) imageUrlString{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 10/10);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: imageUrlString]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self addSubview:self.imageView];
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

#pragma mark - UIView Touch Events
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.beacon.type isEqualToString:@"url"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.beacon.url]];
    }
}

@end
