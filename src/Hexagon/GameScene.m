//
//  GameScene.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "GameScene.h"

#define MAX_LEVEL_CAP 2

@implementation GameScene

Level *level;
int curr_level;

-(instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if(self)
    {
        curr_level = 1;
        
        //init
        self.backgroundColor = [UIColor colorWithRed:110 green:197 blue:233 alpha:1.0];
        
        level = [[Level alloc] initWithData:[NSArray arrayWithObjects: self, [NSString stringWithFormat:@"Level_%i", curr_level], nil]];
    }
    return self;
}

-(void)resetLevel:(NSString *) lvl
{
    for(SKNode *node in self.children)
    {
       [node runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction removeFromParent], nil]]];
    }
    level = [[Level alloc] initWithData:[NSArray arrayWithObjects: self, lvl, nil]];
}

int a = 0;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //detecting touch movements ;)
    UITouch *touch = [touches anyObject];
    
    if([[self childNodeWithName:@"reset"] containsPoint:[touch locationInNode:self]])
    {
        [self resetLevel:[NSString stringWithFormat:@"Level_%i", curr_level]];
    }
    
    [level touchLogicWithTouch:touch];
    
    if([level isLevelWon])
    {
        curr_level++;
        if(curr_level > MAX_LEVEL_CAP)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You've Tried to Call Another Level That Doesn't Exist!" message:@"Alert the shitty developer, he might fix it!" delegate:self cancelButtonTitle:@"K" otherButtonTitles:nil, nil];
            [alert show];
            curr_level--;
        }
        else
        {
            [self resetLevel:[NSString stringWithFormat:@"Level_%i", curr_level]];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
}

@end
