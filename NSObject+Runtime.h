//
//  NSObject+Runtime.h
//  NSObject
//
//  Created by hello on 2016/12/13.
//  Copyright © 2016年 smart_small. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Runtime)

//dic 网络数据 mapDic 映射之后的字典
- (void)fetchValueFormNetDict:(NSDictionary*)dic andMapDic:(NSDictionary*)MapDic;


@end
