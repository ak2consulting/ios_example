//
//  SYWebViewController.m
//  Singly API Example
//
//  Written by Justin Mecham <justin@mecham.net>
//  Copyright (c) 2012 Singly, Inc. All rights reserved.
//

#import "SYWebViewController.h"

@implementation SYWebViewController

@synthesize endpoint;
@synthesize token;
@synthesize webView;

- (void)viewWillAppear:(BOOL)animated
{
  NSURL *endpointURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", endpoint, token]];
  NSLog(@"Requesting URL: %@", endpointURL);
  NSURLRequest *request = [NSURLRequest requestWithURL:endpointURL];
  [self.webView loadRequest:request];
}

@end
