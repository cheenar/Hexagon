//
//  ColorUtil.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/15/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil

+(UIColor *)generateRandomColor
{
    double r = arc4random_uniform(256) / 255.0;
    double g = arc4random_uniform(256) / 255.0;
    double b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
