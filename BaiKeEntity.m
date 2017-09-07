//
//  BaiKeEntity.m
//  Pregnancy
//
//  Created by giming on 2014/3/1.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "BaiKeEntity.h"

@implementation BaiKeEntity


- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.BaiKeId = data[@"id"];
        self.title = data[@"title"];
        self.content = data[@"content"];
        self.photoName = data[@"photoName"];
    }
    return self;
}

@end
