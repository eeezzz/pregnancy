//
//  UpdateViewController.h
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface UpdateViewController : UIViewController<UIAlertViewDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;



@end
