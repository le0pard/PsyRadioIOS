//
//  AboutViewController.h
//  PsyRadio
//
//  Created by Alex on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutViewControllerDelegate;

@interface AboutViewController : UIViewController {
    id <AboutViewControllerDelegate> delegate;
    UIImageView *logoImage;
}

@property (assign) id <AboutViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *logoImage;

- (IBAction)done;

@end

@protocol AboutViewControllerDelegate

- (void)logoInOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)aboutViewControllerDidFinish:(AboutViewController *)controller;

@end
