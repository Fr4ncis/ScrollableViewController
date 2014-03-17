//
//  PageControl.m
//  ScrollableViewControllerDemo
//
//  Created by Francesco Mattia on 10/03/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import "PageControl.h"

@interface Dot : UIView
@property (nonatomic, assign) BOOL on;
@end
@implementation Dot

- (void)drawRect:(CGRect)rect
{
    PageControl *pageControl = (PageControl*)[self superview];
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, pageControl.dotSize, pageControl.dotSize)];
    [(self.on?[pageControl onColor]:[pageControl offColor]) setFill];
    [ovalPath fill];
    self.alpha = self.on?1:pageControl.offAlpha;
}

@end

@implementation PageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.onColor = [UIColor blackColor];
        self.offColor = self.onColor;
        self.backgroundColor = [UIColor clearColor];
        self.offAlpha = 0.3f;
        self.dotSize = 5;
        self.spacing = 5;
    }
    return self;
}

- (void)setOnColor:(UIColor *)onColor
{
    _onColor = onColor;
    [self setNeedsLayout];
}

- (void)setOffColor:(UIColor *)offColor
{
    _offColor = offColor;
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(int)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self setNeedsLayout];
}

- (void)setCurrentPage:(int)currentPage
{
    _currentPage = currentPage;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    float totalWidth = (self.dotSize+self.spacing)*self.numberOfPages - self.spacing;
    float offset = ((self.frame.size.width-totalWidth)/2.0);
    for (int i = 0; i < self.numberOfPages; i++)
    {
        Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, self.dotSize, self.dotSize)];
        dot.on = (i == self.currentPage);
        dot.backgroundColor = [UIColor clearColor];
        dot.center = CGPointMake(offset+(2*i+1)*self.dotSize/2.0+i*self.spacing, self.frame.size.height/2.0);
        [self addSubview:dot];
    }
}


@end
