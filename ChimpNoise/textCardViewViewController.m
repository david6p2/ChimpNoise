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
    self.titleLabel.text = self.card.businessName;
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    
    //continue building the string
    [html appendString:self.card.message];
    [html appendString:@"</body></html>"];
    
    //instantiate the web view
    
    //make the background transparent
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [self.webView loadHTMLString:[html description] baseURL:nil];
    
    self.webView.layer.cornerRadius = 15.0;
    self.webView.layer.borderWidth = 0.5;
    self.webView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.webView setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
