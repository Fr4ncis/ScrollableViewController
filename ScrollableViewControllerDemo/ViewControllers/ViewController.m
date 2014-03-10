//
//  ViewController.m
//  ScrollableViewControllerDemo
//
//  Created by Francesco Mattia on 04/02/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

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
    [self.view setBackgroundColor:@[[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor], [UIColor yellowColor]][[self.theNumber intValue]-1]];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"(%d) viewDidLoad", [self.theNumber intValue]);
    self.label.text = @"";
    [self.activityIndicator startAnimating];
    [self performSelector:@selector(loadedScreen) withObject:Nil afterDelay:3.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"(%d) viewDidAppear", [self.theNumber intValue]);

}

- (void)loadedScreen
{
    [self.activityIndicator stopAnimating];
    self.label.text = [self.theNumber stringValue];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"(%d) viewWillAppear", [self.theNumber intValue]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
