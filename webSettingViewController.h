//
//  webSettingViewController.h
//  Pregnancy
//
//  Created by giming on 2014/4/29.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface webSettingViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)exitTouch:(UIButton *)sender;

@end
