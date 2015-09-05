//
//  QTQuestion.h
//  01-超级猜图
//
//  Created by 蔡钦童 on 15/8/28.
//  Copyright (c) 2015年 Cass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTQuestion : NSObject

@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,strong) NSArray *options;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) questionWithDict:(NSDictionary *)dict;
@end
