//
//  Infos.h
//  Pregnancy
//
//  Created by giming on 2014/3/26.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Infos : NSManagedObject

@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) NSString * beginDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * type;


// 自定義欄位，沒有跟資料庫做 Mapping
@property (nonatomic, strong) NSString* photoURLString;
@end
