//
//  ZhouTiXingScrollViewController.h
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface ZhouTiXingScrollViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weekImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)changeCurrentPage:(UIPageControl *)sender;

@property (nonatomic, weak) AppDelegate* appDelegate;

@end
