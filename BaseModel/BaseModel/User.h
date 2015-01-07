//
//  User.h
//  BaseModel
//
//  Created by 王岩 on 15-1-7.
//  Copyright (c) 2015年 wangyan. All rights reserved.
//

#import "BaseModel.h"
#import "Book.h"

@interface User : BaseModel
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* age;
@property(nonatomic,retain)Book* lovestBook;
@property(nonatomic,retain)NSArray* books;

@end
