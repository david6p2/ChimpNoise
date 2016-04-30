//
//  TextBeaconCardType.m
//  ChimpNoise
//
//  Created by Andres Yepes on 1/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "TextBeaconCardType.h"

@implementation TextBeaconCardType

-(instancetype)initWithFrame:(CGRect)frame beacon:(Card *)beacon{
    self = [super initWithFrame:frame];
    
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    
    //continue building the string
    [html appendString:beacon.message];
    [html appendString:@"</body></html>"];
    
    //instantiate the web view
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    
    //make the background transparent
    [webView setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [webView loadHTMLString:[html description] baseURL:nil];
    
    //add it to the subview
    [self addSubview:webView];
    return self;
}

@end
