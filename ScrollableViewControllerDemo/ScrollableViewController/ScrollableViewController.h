//
//  ScrollableViewController.h
//  ScrollableViewControllerDemo
//
//  Created by Francesco Mattia on 04/02/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollableViewController : UITabBarController <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, strong) UIColor *titleTint;
@property (nonatomic, strong) NSArray *titles;

- (void)reload;

@end
