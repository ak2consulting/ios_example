//
//  SYWebViewController.h
//  Singly API Example
//
//  Written by Justin Mecham <justin@mecham.net>
//  Copyright (c) 2012 Singly, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWebViewController : UIViewController

@property (weak, nonatomic) NSString *endpoint;
@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
