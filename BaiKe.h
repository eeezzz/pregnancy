//
//  BaiKe.h
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BaiKe : NSManagedObject

@property (nonatomic, retain) NSNumber * baiKeId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * photoName;

// 自定義欄位，沒有跟資料庫做 Mapping
@property (nonatomic, strong) NSString* photoURLString;

@end
