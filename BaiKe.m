//
//  BaiKe.m
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "BaiKe.h"


@implementation BaiKe

@dynamic baiKeId;
@dynamic title;
@dynamic content;
@dynamic photoName;

// 自定義欄位，沒有跟資料庫做 Mapping，做為點擊Cell時，傳輪圖片路徑用。
@synthesize photoURLString;

@end
