//
//  ViewController.h
//  AntiAliasingDemo
//
//  Created by Mark Pospesel on 3/26/12.
//  Copyright (c) 2012 Odyssey Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


- (IBAction)playPausePressed:(id)sender;

@end
