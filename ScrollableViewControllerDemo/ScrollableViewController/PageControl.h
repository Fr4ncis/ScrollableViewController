//
//  PageControl.h
//  ScrollableViewControllerDemo
//
//  Created by Francesco Mattia on 10/03/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int numberOfPages;
@property (nonatomic, assign) float spacing;
@property (nonatomic, assign) float dotSize;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, assign) float offAlpha;

@end
