//
//  User.m
//  BaseModel
//
//  Created by 王岩 on 15-1-7.
//  Copyright (c) 2015年 wangyan. All rights reserved.
//

#import "User.h"
#import "Book.h"

@implementation User
-(NSDictionary *)objectClassInArray
{

    return @{@"books":[Book class]};
}
@end
