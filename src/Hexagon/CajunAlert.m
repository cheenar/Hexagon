//
//  CajunAlert.m
//  Hexagon
//
//  Created by Cheenar Gupte on 7/14/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import "CajunAlert.h"

@implementation CajunAlert

-(instancetype)initWithScene:(SKScene *)s andWithTitleColor:(UIColor *)tC andWithMessageColor:(UIColor *)mC andWithBackgroundColor:(UIColor *)bC
{
    self = [super init];
    if(self)
    {
        scene = s;
        titleColor = tC;
        messageColor = mC;
        backgroundColor = bC;
        isShowing = NO;
        
        if(titleColor == nil)
        {
            titleColor = [UIColor blackColor];
        }
        if(messageColor == nil)
        {
            messageColor = [UIColor blackColor];
        }
        if(backgroundColor == nil)
        {
            backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}

-(void)alertWithTitle:(NSString *)title andWithMessage:(NSString *)message
{
    bg = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, scene.size.width, 40)];
    bg.position = CGPointMake(0, scene.size.height + 50);
    bg.fillColor = backgroundColor;
    bg.zPosition = 69;
    bg.name = @"AlertBackground";
    
    lbl_title = [SKLabelNode labelNodeWithText:title];
    lbl_title.fontColor = titleColor;
    lbl_title.fontName = @"HelveticaNeue-Medium ";
    lbl_title.fontSize = 14;
    lbl_title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    if([message isEqualToString:@""])
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height / 2);
    }
    else
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height - 16);
    }
    lbl_title.zPosition = 70;
    lbl_title.name = @"AlertTitle";
    
    lbl_message = [SKLabelNode labelNodeWithText:message];
    lbl_message.fontColor = titleColor;
    lbl_message.fontName = @"HelveticaNeue-Medium ";
    lbl_message.fontSize = 14;
    lbl_message.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    lbl_message.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height - 32);
    lbl_message.zPosition = 70;
    lbl_message.name = @"AlertMessage";
}

-(void)setTitleText:(NSString *)text;
{
    lbl_title.text = text;
    if([lbl_message.text isEqualToString:@""])
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height / 2);
    }
    else
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height - 16);
    }
}

-(void)setMessageText:(NSString *)text;
{
    lbl_message.text = text;
    if([lbl_message.text isEqualToString:@""])
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height / 2);
    }
    else
    {
        lbl_title.position = CGPointMake(bg.frame.size.width / 2, bg.frame.size.height - 16);
    }
}

-(void)setBackgroundColor:(UIColor *)color
{
    backgroundColor = color;
    bg.fillColor = backgroundColor;
}

-(void) show
{
    if(isShowing == NO)
    {
        [bg addChild:lbl_title];
        [bg addChild:lbl_message];
        [scene addChild:bg];
        isShowing = YES;
        SKAction *action = [SKAction sequence:[NSArray arrayWithObjects:[SKAction moveToY:scene.frame.size.height - 40 duration:1.0], [SKAction waitForDuration:DEFAULT_TIME], [SKAction moveToY:scene.frame.size.height + 110 duration:1.0], nil]];
        [bg runAction:action completion:^{
            [self hide];
            NSLog(@"Alert Was Shown!");
        }];
    }
    else
    {
        [self hide];
        [self show];
    }
}

-(void) hide
{
    if(isShowing)
    {
        [lbl_title removeFromParent];
        [lbl_message removeFromParent];
        [bg removeFromParent];
        isShowing = NO;
    }
}

-(BOOL) isAlertShowing
{
    return isShowing;
}

@end
