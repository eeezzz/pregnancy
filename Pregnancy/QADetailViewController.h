//
//  QADetailViewController.h
//  Pregnancy
//
//  Created by giming on 2014/3/6.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QADetailViewController : UIViewController


// 用以接收 BaiKeViewController 傳過來的資料
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* photoname;
@property (nonatomic, strong) NSString* photoURLString;

@property (nonatomic, copy) NSString* navigationTitle;

@end
