//
//  Tile.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "Tile.h"

@implementation Tile
@synthesize _tile_obj_node, isPlayer;

BOOL isRotating;

-(instancetype) initWithScene:(SKScene *)scene andWithType:(T_Type)type andWithPos:(CGPoint)point
{
    self = [super init];
    
    if(self)
    {
        isRotating = false;
        [self spawnTile:scene withType:type andWithPosXY:point];
    }
    
    return self;
}

-(NSString *)randomNormalLilypad
{
    int a = arc4random_uniform(3);
    a = a + 1;
    return [NSString stringWithFormat:@"lily_%i.png", a];
}

-(int) generateRotationAngle
{
    int a = arc4random_uniform(30);
    a = a + 1; //no more 0s
    
    int b = arc4random_uniform(2);
    if(b == 1) //apply negative rotation
    {
        a = a * -1;
    }
    
    return a;
}

-(void)applyRandomTileRotation
{
    int a = arc4random_uniform(2);
    if(a == 1)
    {
        isRotating = true;
        [_tile_obj_node runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction rotateByAngle:[self generateRotationAngle] duration:80], [SKAction waitForDuration:0.5], nil]]]];
    }
}

-(UIColor *)blockIdentity:(T_Type)type
{
    switch (type) {
            
        case NORMAL:
            _tile_obj_node.name = @"NORMAL_BLOCK";
            return [UIColor purpleColor];
        
        case BLACK:
            _tile_obj_node.name = @"BLACK_BLOCK";
            return [UIColor blackColor];
            
        case INVISIBLE:
            _tile_obj_node.name = @"INVISIBLE_BLOCK";
            return [UIColor whiteColor];
        
        case ORANGE:
            _tile_obj_node.name = @"ORANGE";
            return [UIColor orangeColor];
        
        case WIN:
            _tile_obj_node.name = @"WIN_BLOCK";
            return [UIColor greenColor];
        
        default:
            return [UIColor blueColor];
    
    }
}

-(void)runIDChange:(T_Type)type
{
    [_tile_obj_node runAction:[SKAction colorizeWithColor:[self blockIdentity:type] colorBlendFactor:0.5 duration:0.0]];
    
    if(type == NORMAL)
    {
        [_tile_obj_node runAction:[SKAction colorizeWithColor:[self blockIdentity:type] colorBlendFactor:0.5 duration:0.0]];
        [self applyRandomTileRotation];
    }
    
    if(type == INVISIBLE)
    {
        [_tile_obj_node runAction:[SKAction fadeAlphaTo:0 duration:0.0]];
    }
    else
    {
        [_tile_obj_node runAction:[SKAction fadeAlphaTo:1.0 duration:0.0]];
    }
}

-(void)spawnTile:(SKScene *)scene withType:(T_Type)type andWithPosXY:(CGPoint)posxy
{
    if(type == PLAYER)
    {
        isPlayer = YES;
        
        _tile_obj_node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"hexagon_player.png"]];
        _tile_obj_node.name = @"PLAYER";
    }
    else
    {
        isPlayer = NO;
        _tile_obj_node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"hexagon_base.png"]]; //this is just a placeholder
        _tile_obj_node.name = @"REGULAR_BLOCK";
    }
    _tile_obj_node.position = posxy;
    [_tile_obj_node setScale:0.05];
    _tile_obj_node.zPosition = 1;
    _tile_obj_node.anchorPoint = CGPointMake(0.5, 0.5);
    if(type != PLAYER)
    {
        [self runIDChange:type]; //changes the picture to a random, also adds random rotation?
    }
}

@end
