//
//  UIButton+Block.h
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^ActionBlock)(UIButton* button);

@interface UIButton (Block)

- (void) handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock) block;
- (void) setup:(NSString*)title fontsize:(CGFloat)size fontColor:(UIColor*)fcolor bkColor:(UIColor*)bkcolor;
- (void) setup:(UIImage*)image framesize:(CGSize)size;
- (void) buttonWithLeft:(NSString*)title right:(UIImage*)image;
- (void) buttonWith:(UIColor*)backColor verticalLine:(UIColor*)lineColor leftTitle:(NSString*)title rightImage:(UIImage*)image;

@end
