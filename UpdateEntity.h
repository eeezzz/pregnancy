//
//  UpdateEntity.h
//  Pregnancy
//
//  Created by giming on 2014/3/25.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateEntity : NSObject

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, retain) NSNumber* itemId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString* endDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *photoName;

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSString* photoURLString;

- (id) initWithJsonData:(NSDictionary*)data;
@end
