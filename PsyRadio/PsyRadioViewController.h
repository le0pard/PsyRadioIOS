//
//  PsyRadioViewController.h
//  PsyRadio
//
//  Created by Alex on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Radio;

@interface PsyRadioViewController : UIViewController{
	Radio *radio;
}

@property (nonatomic, retain) Radio *radio;


-(void)loadMainView;
-(void)updateTitle:(NSString*)title;
-(void)updateGain:(float)value;
-(void)updatePlay:(BOOL)play;
-(void)updateBuffering: (BOOL)value;


@end
