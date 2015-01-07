//
//  BaseModel.m
//  WYCode
//
//  Created by 王岩 on 14-12-22.
//  Copyright (c) 2014年 wangyan. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>


@interface BaseModel ()
- (NSDictionary *)properties_aps;

@end


@implementation BaseModel


-(id) initWithJSON:(id)JSon{
    self = [self init];
    if (self) {
        [self toEntity:JSon];
    }
    return self;
}
-(NSDictionary*)toDic
{
    NSDictionary *aa = [self properties_aps];
    return aa;
}
-(void) toEntity:(id)JSon
{
    if (!JSon||![JSon isKindOfClass:[NSDictionary class]])  return;
    NSDictionary *dic = JSon;
    
    Class class = [self class];
    while (![NSStringFromClass(class) isEqualToString:@"NSObject"]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
       // NSLog(@"outcount=%d",outCount);
        for (i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            

            //NSString *propertyName = [[[NSString alloc] initWithCString:property_getName(property)] autorelease];
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
          //  NSLog(@"propertyname=%@",propertyName);
            NSString* type=   [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
          //  NSLog(@"type=%@",type);
            type=[type substringFromIndex:3];
            
            NSRange range=[type rangeOfString:@","];
            type=[type substringToIndex:range.location-1];
           // NSLog(@"type=%@",type);
            Class classs=NSClassFromString(type);
           
        
            if ([classs isSubclassOfClass:[BaseModel class]]) {
                id subModel=[[classs alloc]init];
                [subModel toEntity:[dic objectForKey:propertyName]];
                [self setValue:subModel forKey:propertyName];
            }
            else if ([classs isSubclassOfClass:[NSArray class]])
            {
                NSArray* arrayValue=[dic objectForKey:propertyName];
                //[self setValue:arrayValue forKey:propertyName];
                NSMutableArray* newArrayValue=[NSMutableArray arrayWithArray:arrayValue];
                if([self respondsToSelector:@selector(objectClassInArray)])
                {
                    NSDictionary* classDic=[self objectClassInArray];
                    //可以做到支持数组里存放不同的类，但是实际的项目中，没必要出现这种情况。
                    if (classDic&&classDic.count==1) {
                        Class clazz=classDic.allValues[0];
                    //    NSLog(@"arryClass=%@",NSStringFromClass(clazz));
                        for (int j=0; j<newArrayValue.count; j++) {
                            id subArryModel=[[clazz alloc]init];
                            [subArryModel toEntity:arrayValue[j]];
                      //      NSLog(@"subArrayModleClass=%@",NSStringFromClass([subArryModel class]));
                            newArrayValue[j]=subArryModel;
                        }
                        
                        
                    }

                }
               // NSLog(@"newArrayValue=%@",newArrayValue);
                [ self setValue:newArrayValue forKey:propertyName];
                
            }
                else {
                id virableStr = [dic objectForKey:propertyName];
                //NSLog(@"值＝%@",virableStr);
                if (virableStr == [NSNull null]) {
                    NSLog(@"null啊啊啊 ");
                    // Do something for a null
                    //NSLog(@"haha=%@",virableStr);
                }
                //                else if(virableStr!=nil&&virableStr!=@"") {
                //                    [self setValue:virableStr forKey:propertyName];
                //                }
                else if(virableStr&&virableStr!=nil) {
                    [self  setValue:virableStr forKey:propertyName];
                }
                else
                    [self setValue:@"" forKeyPath:propertyName];
                
            }
        }
        free(properties); 
        class = [class superclass];
      //  NSLog(@"superclass=%@",NSStringFromClass(class));
    }
}
- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    Class class = [self class];
    while (![NSStringFromClass(class) isEqualToString:@"NSObject"]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            //NSString *propertyName = [[[NSString alloc] initWithCString:property_getName(property)] autorelease];
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            //NSString *attr = [[[NSString alloc] initWithCString:property_getAttributes(property)] autorelease];
            id propertyValue = [self valueForKey:(NSString *)propertyName];
            //NSLog(@"名称:%@--值:%@---属性:%@",propertyName,propertyValue,attr);
            if ([propertyValue isKindOfClass:[BaseModel class]]) {
                BaseModel *subClass = (BaseModel*)propertyValue;
                propertyValue = [subClass toDic];
            }
            else if ([propertyValue isKindOfClass:[NSArray class]])
            {
                if([self respondsToSelector:@selector(objectClassInArray)])
                {
                
                    NSMutableArray* newPropertyValue=[[NSMutableArray alloc]initWithCapacity:[propertyValue count]];
                    for (int j=0; j<[propertyValue count]; j++) {
                        id arrayModel=propertyValue[j];
                      
                        NSDictionary* arryDic=[arrayModel toDic];
                        newPropertyValue[j]=arryDic;
                    }
                    propertyValue=newPropertyValue;
            }
            }
            if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        }
        free(properties);
        class = [class superclass];
    }
    return props;
}


@end
