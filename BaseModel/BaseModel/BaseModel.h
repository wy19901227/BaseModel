//
//  BaseModel.h
//  WYCode
//
//  Created by 王岩 on 14-12-22.
//  Copyright (c) 2014年 wangyan. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface BaseModel : NSObject

//Json object converted to an object
-(id) initWithJSON:(id)JSon;
//An object converted to json object
- (id) toDic;
//数组中的对象类class；（只支持数组中一种自定义类别）
- (NSDictionary *)objectClassInArray;
@end
