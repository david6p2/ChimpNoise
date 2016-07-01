//
//  TextCardViewViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 5/9/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "TextCardViewViewController.h"

@interface TextCardViewViewController ()

@end

@implementation TextCardViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init Favorite Deck
    self.favoritesDeck = [FavoritesDeck sharedInstance];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.titleLabel.text = self.card.businessName;
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    
    //continue building the string
    [html appendString:self.card.message];
    [html appendString:@"<style type=\"text/css\">*{-webkit-touch-callout:none;-webkit-user-select: none;}</style>"];
    [html appendString:@"</body></html>"];
    
    //instantiate the web view
    
    //make the background transparent
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [self.webView loadHTMLString:[html description] baseURL:nil];
    
    //Card Border and cornerRadius
    self.viewContainer.layer.cornerRadius = 15.0;
    self.viewContainer.layer.borderWidth = 0.5;
    self.viewContainer.layer.borderColor = [UIColor blackColor].CGColor;
    [self.viewContainer setClipsToBounds:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
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
                                                                   self.favoriteHeartImageView.image = [UIImage imageNamed: @"favorite_heart_remove.png"];
                                                               }];
        [alert addAction:addToFavorites];
    }
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
