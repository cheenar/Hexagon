//
//  Tile.h
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum
{
    
    NORMAL,
    BLACK,
    WIN,
    INVISIBLE,
    ORANGE,
    PLAYER
    
} T_Type;

@interface Tile : NSObject
{
    
}

-(instancetype) initWithScene:(SKScene *)scene andWithType:(T_Type)type andWithPos:(CGPoint)point;
-(void)runIDChange:(T_Type)type;

@property SKSpriteNode *_tile_obj_node;
@property BOOL isPlayer;

@end
