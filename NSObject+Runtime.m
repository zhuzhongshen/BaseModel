//
//  NSObject+Runtime.m
//  NSObject
//
//  Created by hello on 2016/12/13.
//  Copyright © 2016年 smart_small. All rights reserved.
//

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

- (void)fetchValueFormNetDict:(NSDictionary*)dic andMapDic:(NSDictionary*)MapDic{
    
    NSArray *properties = [self getAllProperties];
    //需要映射
    if (MapDic !=nil) {
        NSArray *allKeys = dic.allKeys;
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithCapacity:allKeys.count];
        for (int i = 0; i < allKeys.count; i ++) {
            NSString *key = allKeys[i];
            [temDic setObject:dic[key] forKey:MapDic[key]];
        }
        //遍历属性数组
        for (NSString  *key in properties) {
            //判断字典中是否包含这个key
            [self  setValue:temDic[key] forKeyPath:key];
        }
    }
    else//不需要映射
    {
        //遍历属性数组
        for (NSString  *key in properties) {
            //判断字典中是否包含这个key
            [self setValue:dic[key] forKeyPath:key];
            
        }
        
    }
    //null或者 nil处理
    [self  nullDeal];
}
//获取所有的属性名

- (NSArray*)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}




-(void)nullDeal

{
    //找到属性对应的类型
    NSDictionary *typeDic = [self classPropsFor:[self class]];
    NSArray *arr = typeDic.allKeys;
    //所有属性名字
    
    for (int i = 0; i < arr.count;i++) {
        //属性类型名字（字符串格式）
        NSString *typeString = typeDic[arr[i]];
        
        if ([[self valueForKey:arr[i]] isKindOfClass:[NSNull class]] || [self valueForKey:arr[i]] == nil) {
            if ([typeString isEqualToString:@"NSArray"])
            {
                [self setValue:@[]  forKey:arr[i]];
            }
            if ([typeString  isEqualToString:@"NSString"])
            {
                [self setValue:@"" forKey:arr[i]];
            }
            if ([typeString
                 isEqualToString:@"NSNumber"])
            {
                [self setValue:@0  forKey:arr[i]];
            }
            if ([typeString isEqualToString:@"NSDictionary"])
            {
                [self setValue:@{} forKey:arr[i]];
            }
            if ([typeString isEqualToString:@"B"])
            {
                [self setValue:0 forKey:arr[i]];
            }
            if ([typeString   isEqualToString:@"f"])
            {
                [self setValue:0 forKey:arr[i]];
            }
            if ([typeString isEqualToString:@"d"])
            {
                [self setValue:0 forKey:arr[i]];
            }
            if ([typeString isEqualToString:@"i"])
            {
                [self setValue:0 forKey:arr[i]];
            }
        }
    }
}
//获取属性名称数组
- (NSDictionary *)classPropsFor:(Class)klass

{
    
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    unsigned
    int outCount, i;
    objc_property_t *properties  = class_copyPropertyList(klass,&outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            
            NSLog(@"propertyName%@ propertyType %@", propertyName, propertyType);
            [results setObject:propertyType forKey:propertyName];
        }
        
    }
    free(properties);
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
    
}

//获取属性类型的方法c语言写法
// T@"NSString",C,N,V_name  Tf,N,V__float
static  const char  *getPropertyType(objc_property_t property) {
    const char *attributes =
    property_getAttributes(property);
    printf("attributes=%s\n",attributes);
    char buffer[1+ strlen(attributes)];//多一个结束符号
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute =strsep(&state,",")) != NULL) {
        
        if (attribute[0] == 'T' && attribute[1]!= '@') {
            
            NSString *name = [[NSString alloc]initWithBytes:attribute +1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0]  == 'T' && attribute[1] == '@' && strlen(attribute) ==2) {
            // it's an ObjC id type:
            return "id";
        }else if (attribute[0]== 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc]initWithBytes:attribute +3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        
    }
    return  "";
    
}

@end
