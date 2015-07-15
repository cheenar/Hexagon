//
//  Level.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/12/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "Level.h"

@implementation Level
@synthesize levelDesign;

NSMutableArray *text_array;

BOOL isLevelCompleted;
NSMutableArray *arr_block_tiles;

-(NSMutableArray *)getBlocks
{
    return arr_block_tiles;
}

-(void)parseText
{
    text_array = [NSMutableArray array];
    
    int pos_of_line_sep = -1;
    int zpos = 0;
    
    BOOL containsText = NO;
    
    for(NSString *line in levelDesign)
    {
        if([line containsString:@"-"])
        {
            //this line is the text separator
            pos_of_line_sep = zpos;
            NSLog(@"%i", pos_of_line_sep);
            containsText = YES;
            break;
        }
        zpos++;
    }
    
    NSMutableArray *ontengco_array = [NSMutableArray array];
    
    if(pos_of_line_sep != levelDesign.count - 1 && containsText)
    {
        for(int i = pos_of_line_sep; i < levelDesign.count; i++)
        {
            [text_array addObject:[levelDesign objectAtIndex:i]];
            NSLog(@"%@", [levelDesign objectAtIndex:i]);
        }
        
        for(int i = 0; i < pos_of_line_sep; i++)
        {
            [ontengco_array addObject:[levelDesign objectAtIndex:i]];
        }
        
        levelDesign = ontengco_array;
        [text_array removeObjectAtIndex:0];
    }
}

NSThread *thread;

-(void)drawTextSelector
{
    CajunAlert *ca = [[CajunAlert alloc] initWithScene:scene andWithTitleColor:[UIColor whiteColor] andWithMessageColor:[UIColor whiteColor] andWithBackgroundColor:[UIColor orangeColor]];
    [ca alertWithTitle:@"" andWithMessage:@""];
    
    for(int i = 0; i < text_array.count; i+=2)
    {
        [ca setBackgroundColor:[ColorUtil generateRandomColor]];
        
        [ca setTitleText:@""];
        [ca setMessageText:@""];
        if(i < text_array.count)
        {
            [ca setTitleText:[text_array objectAtIndex:i]];
        }
        if(i+1 < text_array.count)
        {
            [ca setMessageText:[text_array objectAtIndex:i+1]];
        }
        [ca show];
        [NSThread sleepForTimeInterval:5.0];
    }
    [thread cancel];
}

-(void)drawText
{
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawTextSelector) object:nil];
    [thread start];
}


-(instancetype) initWithData:(NSArray *) data
{
    self = [super init];
    if(self)
    {
        isLevelCompleted = NO;
        arr_block_tiles = [NSMutableArray array];
        
        //c_Vars
        scene = [data objectAtIndex:0];
        level_id = [data objectAtIndex:1];
        
        //level_design init
        NSString *_path = [[NSBundle mainBundle] pathForResource:level_id ofType:@"cml"];
        NSString *_content = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:nil];
        
        levelDesign = [NSMutableArray arrayWithArray:[_content componentsSeparatedByString:@"\n"]];
        
        /** Parse Level Design **/
        
        //run the parser
        [self parseText];
        [self drawText];
        
        //completed parsing level design
        
        level_width = [StringUtil longestStringFromArray:levelDesign].length;
        level_height = levelDesign.count;
        
        
        //screen width/height math
        //when drawing to the screen, utilize the temp vars values for the math (add it to the final values)
        screen_height = scene.frame.size.height;
        screen_width = scene.frame.size.width;
        
        
        //drawing the level ;^)
        [self drawBasicInterface];
        [self drawLevel];
    }
    return self;
}

-(void)drawBasicInterface
{
    //creates the hexagon rain
    SKEmitterNode *ex = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"HexagonRainParticle" ofType:@"sks"]];
    ex.position = CGPointMake(scene.size.width / 2, scene.size.height + 20);
    [scene addChild:ex];
    
    SKSpriteNode *reset_button = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"reset.png"]];
    [reset_button setScale:0.05];
    reset_button.name = @"reset";
    reset_button.zPosition = 10;
    reset_button.position = CGPointMake(30, scene.frame.size.height - 30);
    [scene addChild:reset_button];
}

-(void)drawLevel
{
    SKSpriteNode *temp_sprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"hexagon_normal.png"]];
    [temp_sprite setScale:0.05];
    
    long Y_POS = (screen_height - (level_height * temp_sprite.size.height)) / 1.75;
    
    for(int i = 0; i < level_height; i++)
    {
        long X_POS = (screen_width -  (level_width * temp_sprite.size.width)) / 1.75;
        
        if(i > 0)
        {
            Y_POS = Y_POS + temp_sprite.size.height;
        }
        
        for(int j = 0; j < level_width; j++)
        {
            
            if(j > 0)
            {
                X_POS = X_POS + temp_sprite.size.width;
            }
            
            
            int _temp_loc_in_arr = 0;
            NSString *loc_str = @"";
            
            for(NSString *str in levelDesign)
            {
                if(_temp_loc_in_arr == i)
                {
                    loc_str = str;
                    break;
                }
                _temp_loc_in_arr++;
            }
            
            
            //NSString *block_id = [blocks_id objectAtIndex:j];
            char block_id = [loc_str characterAtIndex:j];
            T_Type block_type = NORMAL;
            
            if([loc_str isEqualToString:@""] || [loc_str isEqualToString:nil])
            {
                block_id = INVISIBLE;
            }
            else
            {
                if(block_id == 'X')
                {
                    block_type = NORMAL;
                }
                if(block_id == 'O')
                {
                    block_type = BLACK;
                }
                if(block_id == '*')
                {
                    block_type = INVISIBLE;
                }
                if(block_id == '^')
                {
                    block_type = WIN;
                }
                if(block_id == 'P')
                {
                    block_type = PLAYER;
                }
                if(block_id == 'C')
                {
                    block_type = ORANGE;
                }
            }
            
            Tile *tile = [[Tile alloc] initWithScene:scene andWithType:block_type andWithPos:CGPointMake(X_POS, Y_POS)];
            
            if(j % 2 == 0)
            {
                tile._tile_obj_node.position = CGPointMake(tile._tile_obj_node.position.x, tile._tile_obj_node.position.y + (tile._tile_obj_node.size.height / 2));
            }
            
            [tile._tile_obj_node setAlpha:1];
            
            [scene addChild:tile._tile_obj_node];
            [arr_block_tiles addObject:tile];
        }
    }
}

-(void)touchLogicWithTouch:(UITouch *)touch
{
    
    int pos = 0;
    for(Tile *tile in [self getBlocks])
    {
        if([tile._tile_obj_node.name isEqualToString:@"PLAYER"])
        {
            break;
        }
        pos++;
    }
    
    Tile *playerTile = [[self getBlocks] objectAtIndex:pos];
    
    BOOL breaker = NO;
    
    for(SKNode *node in [scene nodesAtPoint:[touch locationInNode:scene]])
    {
        if([node.name isEqualToString:@"NORMAL_BLOCK"] || [node.name isEqualToString:@"WIN_BLOCK"])
        {
            
            SKSpriteNode *tile_sprite = (SKSpriteNode *)node;
            
            CGPoint upperPoint = CGPointMake(playerTile._tile_obj_node.position.x, playerTile._tile_obj_node.position.y + playerTile._tile_obj_node.size.height);
            CGPoint lowerPoint = CGPointMake(playerTile._tile_obj_node.position.x, playerTile._tile_obj_node.position.y - playerTile._tile_obj_node.size.height);
            
            CGPoint lowerRightPoint = CGPointMake(playerTile._tile_obj_node.position.x + playerTile._tile_obj_node.size.width, playerTile._tile_obj_node.position.y - playerTile._tile_obj_node.size.height);
            CGPoint lowerLeftPoint = CGPointMake(playerTile._tile_obj_node.position.x - playerTile._tile_obj_node.size.width, playerTile._tile_obj_node.position.y - playerTile._tile_obj_node.size.height);
            
            CGPoint upperRightPoint = CGPointMake(playerTile._tile_obj_node.position.x + (playerTile._tile_obj_node.size.width/1), playerTile._tile_obj_node.position.y + (playerTile._tile_obj_node.size.height/2));
            CGPoint upperLeftPoint = CGPointMake(playerTile._tile_obj_node.position.x - (playerTile._tile_obj_node.size.width/1), playerTile._tile_obj_node.position.y + (playerTile._tile_obj_node.size.height/2));
            
            NSLog(@"%f %f %f %f", upperRightPoint.x, upperRightPoint.y, [touch locationInNode:scene].x, [touch locationInNode:scene].y);
            
            CGPoint points[] = { upperPoint, lowerPoint, lowerLeftPoint, upperRightPoint, upperLeftPoint, lowerRightPoint };
            
            //test_node is the node used for the debugger code below (which works ;)
            if([scene childNodeWithName:@"test_node"] != nil)
            {
                [[scene childNodeWithName:@"test_node"] removeFromParent];
            }
            
            //bg player (for the intiially lily)
            if([scene childNodeWithName:@"bg_player"] != nil)
            {
                [[scene childNodeWithName:@"bg_player"] removeFromParent];
            }
            
            //DEBUGGER CODE: (triangle drawn when pressing buttons)
            /*SKShapeNode *test_node = [SKShapeNode shapeNodeWithPoints:points count:6];
             test_node.strokeColor = [UIColor redColor];
             test_node.position = CGPointMake(0, 0);
             test_node.zPosition = 3;
             test_node.name = @"test_node";
             [self addChild:test_node];*/
            
            for(int i = 0; i < 6; i++)
            {
                CGPoint point = points[i];
                
                if([tile_sprite containsPoint:[touch locationInNode:scene]] && [tile_sprite containsPoint:point])
                {
                    if([tile_sprite.name isEqualToString:@"WIN_BLOCK"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!" message:@"You did it! You solved the puzzle!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        
                        /** GAME WIN **/
                        [self onGameWin];
                        
                        isLevelCompleted = YES;
                    }
                    
                    if([scene childNodeWithName:@"player_movement_animation"] != nil)
                    {
                        [[scene childNodeWithName:@"player_movement_animation"] removeFromParent];
                    }
                    SKSpriteNode *player_movement_animation = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"hexagon_player.png"]];
                    player_movement_animation.position = playerTile._tile_obj_node.position;
                    [player_movement_animation setScale:0.05];
                    player_movement_animation.zPosition = 5;
                    player_movement_animation.name = @"player_movement_animation";
                    [scene addChild:player_movement_animation];
                    
                    //[tile_sprite setAlpha:0.0];
                    
                    [player_movement_animation runAction:[SKAction moveTo:tile_sprite.position duration:0.5] completion:^{
                        [tile_sprite runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"hexagon_base.png"]]];
                    }];
                    
                    
                    tile_sprite.colorBlendFactor = 0.0;
                    tile_sprite.name = @"PLAYER";
                    
                    //** TODO - ADD THE ANIMATION FOR THE SPLASHING LILY **/
                    [playerTile._tile_obj_node setTexture:[SKTexture textureWithImageNamed:@"hexagon_base.png"]];
                    [playerTile runIDChange:ORANGE];
                    [playerTile._tile_obj_node setColorBlendFactor:0.5];
                
                    breaker = YES;
                    break;
                }
            }
            
            if(breaker)
            {
                break;
            }
        }
    }
}

-(void)onGameWin
{
    if(([scene childNodeWithName:@"AlertBackground"] != nil) && ([scene childNodeWithName:@"AlertTitle"] != nil) && ([scene childNodeWithName:@"AlertMessage"] != nil))
    {
        [[scene childNodeWithName:@"AlertBackground"] removeFromParent];
        [[scene childNodeWithName:@"AlertTitle"] removeFromParent];
        [[scene childNodeWithName:@"AlertMessage"] removeFromParent];
        NSLog(@"Removed Alert Data");
    }
}

-(BOOL)isLevelWon
{
    return isLevelCompleted;
}

@end
