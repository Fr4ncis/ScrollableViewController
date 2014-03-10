//
//  ScrollableViewController.m
//  ScrollableViewControllerDemo
//
//  Created by Francesco Mattia on 04/02/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import "ScrollableViewController.h"
#import "PageControl.h"

@interface ScrollableViewController () {
    NSSet *visibleSet;
    NSSet *transitioningSet;
    BOOL startedDragging;
    
    UIView *titleContainerView;
    PageControl *pageControl;
    UIScrollView *titleScrollView;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScrollableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)reload
{
    if ([self.viewControllers count] == 0) return;
    
    visibleSet = [NSSet setWithObject:@(0)];
    transitioningSet = [NSSet setWithArray:@[]];
    startedDragging = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.viewControllers count], self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = YES;
    
    self.titleTint = [UIColor blackColor];
    
    //titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width-55.0*2, self.navigationController.navigationBar.frame.size.height)];
    
    titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f-55.0*2, 49.0f)];

    titleContainerView.backgroundColor = [UIColor clearColor];
    titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 140.0f, self.navigationController.navigationBar.frame.size.height)];
    titleScrollView.userInteractionEnabled = NO;
    titleScrollView.bounces = NO;
    titleScrollView.backgroundColor = [UIColor clearColor];
    titleScrollView.contentSize = CGSizeMake(titleScrollView.frame.size.width * [self.viewControllers count], titleScrollView.frame.size.height);
    
    
    for (int i = 0; i < [self.viewControllers count]; i++)
    {
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
        label.backgroundColor = [UIColor clearColor];
        if (self.titles)
        {
            NSAssert([self.titles count] >= [self.viewControllers count],@"Titles should be as many as the viewcontrollers");
            label.text = self.titles[i];
        }
        else
        {
            label.text = [self.tabBar.items[i] title];
        }
        label.textColor = self.titleTint;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = titleScrollView.frame;
        label.center = CGPointMake(titleScrollView.frame.size.width*(2*i+1)/2.0, titleScrollView.frame.size.height/2.0);
        [titleScrollView addSubview:label];
    }
    
    titleContainerView.clipsToBounds = YES;
    titleScrollView.clipsToBounds = NO;
    titleScrollView.center = CGPointMake(titleContainerView.frame.size.width/2.0, titleContainerView.frame.size.height/2.0);
    [titleContainerView addSubview:titleScrollView];
    
    pageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, titleContainerView.frame.size.height-12.0f, titleContainerView.frame.size.width, 6.0f)];
    pageControl.numberOfPages = [self.viewControllers count];
    pageControl.currentPage = 0;
    [titleContainerView addSubview:pageControl];
    
    self.navigationItem.titleView = titleContainerView;
    
    self.tabBar.hidden = YES;
    [self.view addSubview:self.scrollView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // hack to make it work with a UITabBarController
    [[self.viewControllers[0] view] removeFromSuperview];
    [self.scrollView addSubview:[self.viewControllers[0] view]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSSet*)visibleViewControllersForContentOffset:(float)offset
{
    float floorValue = floorf(offset / self.scrollView.frame.size.width);
    float ceilValue  = ceilf(offset / self.scrollView.frame.size.width);
    if (floorValue < 0) floorValue = 0;
    if (ceilValue > [self.viewControllers count]-1) ceilValue = [self.viewControllers count]-1;
    NSSet *set = [NSSet setWithObjects:@(floorValue),@(ceilValue), nil];
    return set;
}

#pragma mark -
#pragma mark Scrollview delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [titleScrollView setContentOffset:CGPointMake(scrollView.contentOffset.x*titleScrollView.contentSize.width/scrollView.contentSize.width, 0)];
    [self adjustSubviewsAlphaForTitleScrollView];
    
    [[self visibleViewControllersForContentOffset:scrollView.contentOffset.x] enumerateObjectsUsingBlock:^(NSNumber* vcNumber, BOOL *stop) {
        UIViewController *vc = self.viewControllers[[vcNumber intValue]];
        if (![vc isViewLoaded])
        {
            [[vc view] setFrame:CGRectMake([vcNumber intValue]*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            [self.scrollView addSubview:vc.view];
        }
    }];
    if (!startedDragging)
    {
        NSSet *newSet = [self visibleViewControllersForContentOffset:scrollView.contentOffset.x];
        NSMutableSet *addedSet = [newSet mutableCopy];
        [addedSet minusSet:visibleSet];
        
        // addedSet viewWillAppear
        [addedSet enumerateObjectsUsingBlock:^(NSNumber* vcNumber, BOOL *stop) {
            UIViewController *vc = self.viewControllers[[vcNumber intValue]];
            [vc viewWillAppear:YES];
        }];

        transitioningSet = addedSet;
        startedDragging = YES;
    }
    
}

- (UIImage*)maskImage
{
    UIImage *defaultImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(titleContainerView.frame.size.width, titleContainerView.frame.size.height), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)[UIColor blackColor].CGColor,
                               (id)[UIColor clearColor].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.5, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, titleContainerView.frame.size.width, titleContainerView.frame.size.height)];
    
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawRadialGradient(context, gradient,
                                CGPointMake(titleContainerView.frame.size.width/2.0, titleContainerView.frame.size.height/2.0), 10.0,
                                CGPointMake(titleContainerView.frame.size.width/2.0, titleContainerView.frame.size.height/2.0), 200.0,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    defaultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return defaultImage;
}

- (void)adjustSubviewsAlphaForTitleScrollView
{
    
    if (!titleContainerView.layer.mask)
    {
        CALayer *mask = [CALayer layer];
        mask.contents = (id)[[self maskImage] CGImage];
        mask.frame = CGRectMake(0, 0, titleContainerView.frame.size.width, titleContainerView.frame.size.height);
        titleContainerView.layer.mask = mask;
        titleContainerView.layer.masksToBounds = YES;
    }
    
//    const float maxDistance = self.scrollView.frame.size.width;
//    for (int i = 0; i < [self.viewControllers count]; i++)
//    {
//        float distance = fabsf(self.scrollView.contentOffset.x - i*self.scrollView.frame.size.width);
//        [[[titleScrollView subviews] objectAtIndex:i] setAlpha:MAX(0.2, (maxDistance-distance)/maxDistance)];
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSSet *newSet = [self visibleViewControllersForContentOffset:targetContentOffset->x];
    NSMutableSet *removedSet = [transitioningSet mutableCopy];
    [removedSet unionSet:visibleSet];
    [removedSet minusSet:newSet];
    
    // removedSet viewWillDisappear
    [removedSet enumerateObjectsUsingBlock:^(NSNumber* vcNumber, BOOL *stop) {
        UIViewController *vc = self.viewControllers[[vcNumber intValue]];
        [vc viewWillDisappear:YES];
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    startedDragging = NO;
    NSSet *newSet = [self visibleViewControllersForContentOffset:scrollView.contentOffset.x];
    NSMutableSet *removedSet = [transitioningSet mutableCopy];
    [removedSet unionSet:visibleSet];
    [removedSet minusSet:newSet];
    NSMutableSet *addedSet = [newSet mutableCopy];
    [addedSet minusSet:visibleSet];
    
    // addedSet viewDidAppear
    [addedSet enumerateObjectsUsingBlock:^(NSNumber* vcNumber, BOOL *stop) {
        UIViewController *vc = self.viewControllers[[vcNumber intValue]];
        [pageControl setCurrentPage:[vcNumber intValue]];
        [vc viewDidAppear:YES];
    }];
    
    // removedSet viewDidDisappear
    [removedSet enumerateObjectsUsingBlock:^(NSNumber* vcNumber, BOOL *stop) {
        UIViewController *vc = self.viewControllers[[vcNumber intValue]];
        [vc viewDidDisappear:YES];
    }];

    visibleSet = newSet;
}

#pragma mark -

- (void)setBounces:(BOOL)bounces
{
    self.scrollView.bounces = bounces;
}

- (BOOL)bounces
{
    return self.scrollView.bounces;
}

- (void)setTitleTint:(UIColor *)titleTint
{
    _titleTint = titleTint;
    pageControl.onColor = titleTint;
    pageControl.offColor = titleTint;
    [titleScrollView.subviews enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.textColor = _titleTint;
    }];
}

#pragma mark -

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self reload];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self reload];
}

@end
