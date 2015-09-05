//
//  QTQuestion.m
//  01-超级猜图
//
//  Created by 蔡钦童 on 15/8/28.
//  Copyright (c) 2015年 Cass. All rights reserved.
//

#import "QTQuestion.h"

@implementation QTQuestion
- (instancetype) initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.answer = dict[@"answer"];
        self.options = dict[@"options"];
    }
    return self;
}


+(instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
