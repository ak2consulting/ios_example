//
//  SYViewController.h
//  Singly API Example
//
//  Written by Justin Mecham <justin@mecham.net>
//  Copyright (c) 2012 Singly, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYViewController : UITableViewController

- (void)authorizeWithFacebook;
- (void)authorizeWithTwitter;
- (void)authorize:(NSString *)service;

@end
