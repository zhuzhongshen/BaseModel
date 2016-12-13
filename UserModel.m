//
//  UserModel.m
//  NSObject
//
//  Created by hello on 2016/12/13.
//  Copyright © 2016年 smart_small. All rights reserved.
//

#import "UserModel.h"
#import "NSObject+Runtime.h"


@implementation UserModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self==[super init]) {
        //   dic 网络数据   mapDic 映射之后的字典
        [self fetchValueFormNetDict:dic andMapDic:[self mapDic]];
    }
    return  self;
}
////设置 映射字典格式：@"网络数据字段名":@"model属性名"
//如果服务器返回的字段 和 model的属性名字不一致则需要映射返回映射字典 否则返回nil表示不需要映射

- (NSDictionary *)mapDic{
    
    return @{@"wzcName":@"name",@"wzcAddress":@"home",@"isbol":@"isBoll"};
    
}

/*
 NSDictionary  *data1 = @{@"wzcName":[NSNull  null],@"wzcAddress":@"杭州市西湖区",@"isbol":@1};
 
 UserModel *model1 = [[UserModel alloc]initWithDic:data1];
 
 */


@end
