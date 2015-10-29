//
//  SecondViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "SecondViewController.h"
#import "AYChimpnoise.h"
#import "AYBeacon.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"SecondView");
    
    AYChimpnoise *chimpnoise = [AYChimpnoise sharedInstance];
    
    AYBeacon * beacon = [[AYBeacon alloc] initWithUUID:@"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"
                                                 minor:[NSNumber numberWithInt:1]
                                                 major:[NSNumber numberWithInt:1]];
    [chimpnoise addBeacon: beacon];
    
    AYBeacon * beacon2 = [[AYBeacon alloc] initWithUUID:@"BEACON-TEST-DOS"
                                                 minor:[NSNumber numberWithInt:4]
                                                 major:[NSNumber numberWithInt:4]];
    [chimpnoise addBeacon: beacon2];
    
    AYBeacon * foundBeacon = [chimpnoise findOrCreateBeaconWithUUID:@"BEACON-TEST"
                                                              minor: [NSNumber numberWithInt:2]
                                                                        major: [NSNumber numberWithInt:2]];
    AYBeacon * foundBeacon2 = [chimpnoise findOrCreateBeaconWithUUID:@"ANOTHER"
                                                               minor: [NSNumber numberWithInt:3]
                                                               major: [NSNumber numberWithInt:3]];
    NSLog(@"%@", foundBeacon.uuid);
    NSLog(@"%@", foundBeacon2.uuid);
    NSLog(@"%@", [[AYChimpnoise sharedInstance].beacons description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
