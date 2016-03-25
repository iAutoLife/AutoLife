//
//  UIButton+Block.m
//  AutoLife
//
//  Created by 徐成 on 16/1/14.
//  Copyright © 2016年 徐成. All rights reserved.
//


#import "UIButton+Block.h"

@implementation UIButton (Block)

static char overViewKey;

- (void) handleControlEvent:(UIControlEvents)event withBlock:(void (^)(UIButton *))block {
    objc_setAssociatedObject(self, &overViewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void) callActionBlock:(UIButton*)button {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overViewKey);
    if (block) {
        block(button);
    }
}

- (void) setup:(NSString*)title fontsize:(CGFloat)size fontColor:(UIColor*)fcolor bkColor:(UIColor*)bkcolor  {
    self.frame = CGRectMake(0, 0, size * title.length + 10, size + 5);
    [self setTitle:title forState:UIControlStateNormal];
    self.backgroundColor = bkcolor;
    self.layer.cornerRadius = 5;
    [self setTitleColor:fcolor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:size];
}

- (void) setup:(UIImage*)image framesize:(CGSize)size {
    self.frame = CGRectMake(0, 0, size.width, size.height);
    [self setImage:image forState:UIControlStateNormal];
}

- (void) buttonWithImage:(UIImage*)image andTitle:(NSString*)title titleColor:(UIColor*)titleColor event:(UIControlEvents)event withBlock:(void (^)(UIButton *))block{
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self setup:image framesize:image.size];
    [self handleControlEvent:event withBlock:block];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, size.width, size.height);
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    
}

- (void) buttonWithLeft:(NSString*)title right:(UIImage*)image {
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width, 0, -self.titleLabel.frame.size.width);

}

- (void) buttonWith:(UIColor*)backColor verticalLine:(UIColor*)lineColor leftTitle:(NSString*)title rightImage:(UIImage*)image {
//    [self buttonWithLeft:title right:image];
    self.backgroundColor = backColor;
    CALayer *layer = [CALayer layer];
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width - 5, 0, 4-self.titleLabel.frame.size.width);
    NSLog(@"current111:%f",CGRectGetMaxX(self.imageView.frame));
    layer.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 3, 0.5, self.frame.size.height - 6);
    layer.backgroundColor = lineColor.CGColor;
    [self.layer insertSublayer:layer atIndex:0];
}

@end
