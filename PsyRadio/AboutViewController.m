//
//  AboutViewController.m
//  PsyRadio
//
//  Created by Alex on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "PsyRadioViewController.h"

@implementation AboutViewController

@synthesize delegate;
@synthesize logoImage = _logoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)done {
	[self.delegate aboutViewControllerDidFinish:self];	
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)logoInOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                self.logoImage.hidden = YES;
            }
            break;
        default:
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                self.logoImage.hidden = NO;
            }
            break;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //logo
    [self logoInOrientation:toInterfaceOrientation];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // rotation
    [self logoInOrientation:self.interfaceOrientation];
    // bg
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sand.png"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
