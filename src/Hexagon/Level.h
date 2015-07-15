//
//  Level.h
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Tile.h"
#import "CajunAlert.h"
#import "ColorUtil.h"
#import "StringUtil.h"

@interface Level : NSObject
{
    SKScene *scene;
    NSString *level_id;
    
    long level_height;
    long level_width;
    
    long screen_height;
    long screen_width;
}

-(instancetype) initWithData:(NSArray *) data;
-(NSMutableArray *)getBlocks;
-(BOOL)isLevelWon;

-(void)touchLogicWithTouch:(UITouch *)touch;

@property NSMutableArray *levelDesign;
@property NSMutableArray *tileDesign;

@end
