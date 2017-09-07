//
//  UpdateEntity.m
//  Pregnancy
//
//  Created by giming on 2014/3/25.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "UpdateEntity.h"

@implementation UpdateEntity


- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.type = data[@"type"];
        self.status = data[@"status"];
        self.itemId = data[@"id"];
        self.title = data[@"title"];
        self.content = data[@"content"];
        
        if (data[@"beginDate"] != [NSNull null]) {
            self.beginDate = data[@"beginDate"];
        }else{
            self.beginDate = @"";
        }
        
        if (data[@"endDate"] != [NSNull null]) {
            self.endDate = data[@"endDate"];
        }else{
            self.endDate = @"";
        }
        

        
        
        
        if (data[@"photoName"] != [NSNull null]) {
            self.photoName = data[@"photoName"];
        }else {
            self.photoName = @"";
        }
        
    }
    return self;
}

@end
