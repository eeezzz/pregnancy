//
//  BaiKeEntity.h
//  Pregnancy
//
//  Created by giming on 2014/3/1.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiKeEntity : NSObject


@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, retain) NSNumber* BaiKeId;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSString* photoURLString;

- (id) initWithJsonData:(NSDictionary*)data;

@end
