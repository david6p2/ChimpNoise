//
//  ImageCardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "ImageCardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

bool a = NO;

@implementation ImageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init Favorite Deck
    self.favoritesDeck = [FavoritesDeck sharedInstance];
    
    //Init Image card
    self.titleLabel.text = self.card.beaconName;

    [self.view setClipsToBounds:YES];
    [self.containerView setClipsToBounds:YES];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imageView setFrame:self.containerView.frame];

    if (self.card.showBackCard) {
        [self.frontView setHidden:YES];
        [self.backView setHidden:NO];
    }
    else{
        [self.frontView setHidden:NO];
        [self.backView setHidden:YES];
    }

    //init Border
    self.containerView.layer.cornerRadius = 15.0;
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;

    
    //Init Long Press Gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:longPress];
    
    //Init Favorite Heart Image View
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favoriteHeartImageView setUserInteractionEnabled:YES];
    [self.favoriteHeartImageView addGestureRecognizer:singleTap];
    if ([self.favoritesDeck contains:self.card]) {
        self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_remove.png"];
    }
    
    //Init Page Curl TempUIview
    self.tempUIView= [[UIView alloc]initWithFrame:self.containerView.bounds];
    self.tempUIView.backgroundColor=[UIColor whiteColor];
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 4
                                                  target: self
                                                selector:@selector(pageCurl)
                                                userInfo: nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Long Press Gesture
-(void)longPressDetected:(UILongPressGestureRecognizer *)longPress
{
    [self showOptionsMenu];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)tapDetected{
    [self showOptionsMenu];
}

-(void) showOptionsMenu{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:self.card.businessName
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self.favoritesDeck contains:self.card]) {
        UIAlertAction* removeFromFavorites = [UIAlertAction actionWithTitle:@"Remove from My Decks"
                                                                      style:UIAlertActionStyleDestructive
                                                                    handler:^(UIAlertAction * action) {
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeCardToFavorites" object:self.card];
                                                                        self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_add.png"];
                                                                    }];
        [alert addAction:removeFromFavorites];
    }
    else{
        UIAlertAction* addToFavorites = [UIAlertAction actionWithTitle:@"Add to My Decks"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"addCardToFavorites" object:self.card];
                                                                   self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_remove.png"];
                                                               }];
        [alert addAction:addToFavorites];
    }
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];        
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}


#pragma mark - Flip
- (IBAction)flipCard:(id)sender {
    NSLog(@"flip!");
    if (self.card.showBackCard == NO) {
        //Show Back View
        self.card.showBackCard = YES;
        [self.frontView setHidden:YES];
        [self.backView setHidden:NO];
        [UIView transitionFromView:self.frontView toView:self.backView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL f){
                            [self viewDidLoad];
                        }];
    }
    else {
        //Show Front View
        self.card.showBackCard = NO;
        [self.frontView setHidden:NO];
        [self.backView setHidden:YES];
        [UIView transitionFromView:self.backView toView:self.frontView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL f){
                            [self viewDidLoad];
                        }];
    }
}

#pragma mark - page curl
-(void) pageCurl{
    [UIView animateWithDuration:2.0
                     animations:^{
                         //http://www.iostute.com/2015/04/how-to-implement-partial-and-full-page.html
                         //Page Curl Animation
                         CATransition *animationPageCurl = [CATransition animation];
                         [animationPageCurl setDuration:2];
                         [animationPageCurl setTimingFunction:[CAMediaTimingFunction functionWithName:@"default"]];
                         animationPageCurl.fillMode = kCAFillModeForwards;
                         [animationPageCurl setRemovedOnCompletion:NO];
                         animationPageCurl.endProgress = 0.2;
                         animationPageCurl.type = @"pageCurl";
                         [[self.containerView layer] addAnimation:animationPageCurl
                                                            forKey:@"pageFlipAnimation"];
//                         [self.containerView addSubview:self.tempUIView];
                         //Page uncurl Animation
                         CATransition  * animationPageUnCurl = [CATransition animation];
                         [animationPageUnCurl setTimingFunction:UIViewAnimationCurveEaseInOut];
                         animationPageUnCurl.startProgress = 0.2;
                         animationPageUnCurl.endProgress   = 0;
                         [animationPageUnCurl setDuration:2];
                         [animationPageUnCurl setTimingFunction:[CAMediaTimingFunction functionWithName:@"default"]];
                         animationPageUnCurl.fillMode = kCAFillModeForwards;
                         [animationPageUnCurl setRemovedOnCompletion:NO];
                         animationPageUnCurl.type = @"pageCurl";
                         [[self.containerView layer] addAnimation:animationPageUnCurl
                                                            forKey:@"pageUnCurlAnimation"];
//                         [self.tempUIView removeFromSuperview];
                     }
     ];
}

@end
