//
//  StringUtil.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+(long)lengthOfString:(NSString *)str
{
    return str.length;
}

+(NSString *)longestStringFromArray:(NSArray *)data
{
    NSString *longestString;
    long longestStringValue = -1;
    
    for(NSString *str in data)
    {
        if([self lengthOfString:str] > longestStringValue)
        {
            longestString = str;
            longestStringValue = str.length;
        }
    }
    
    return longestString;
}

@end
