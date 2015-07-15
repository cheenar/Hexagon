//
//  CajunAlert.h
//  Hexagon
//
//  Created by Cheenar Gupte on 7/14/15.
//  Copyright (c) 2015 Chi Corp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define DEFAULT_TIME 2.5

@interface CajunAlert : NSObject
{
    int _time_duration;
    SKScene *scene;
    UIColor *titleColor;
    UIColor *messageColor;
    UIColor *backgroundColor;
    
    SKShapeNode *bg;
    SKLabelNode *lbl_title;
    SKLabelNode *lbl_message;
    
    BOOL isShowing;
}

-(instancetype)initWithScene:(SKScene *)s andWithTitleColor:(UIColor *)tC andWithMessageColor:(UIColor *)mC andWithBackgroundColor:(UIColor *)bC;
-(void) alertWithTitle:(NSString *)title andWithMessage:(NSString *)message;

-(void)setTitleText:(NSString *)text;
-(void)setMessageText:(NSString *)text;
-(void)setBackgroundColor:(UIColor *)color;

-(void) show;
-(void) hide;
-(BOOL) isAlertShowing;


@end
