//
//  ViewController.m
//  AntiAliasingDemo
//
//  Created by Mark Pospesel on 3/26/12.
//  Copyright (c) 2012 Odyssey Computing. All rights reserved.
//

#define LABEL_GAP 4

#import "ViewController.h"
#import "MPAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (assign, nonatomic, getter = isSpinning) BOOL spinning;
@property (assign, nonatomic) CGRect leftBounds;
@property (assign, nonatomic) CGRect rightBounds;

@end

@implementation ViewController

@synthesize spinning;
@synthesize leftBounds;
@synthesize rightBounds;
@synthesize leftView;
@synthesize rightView;
@synthesize playButton;
@synthesize leftLabel;
@synthesize rightLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Render left view (purple square) as an image with 1 point transparent border around all edges
	UIImage *imageWithTransparentBorder = [MPAnimation renderImageFromView:self.leftView withRect:self.leftView.bounds transparentInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
	
	// The image is now 2 points larger in each dimension
	CGSize imageSize = imageWithTransparentBorder.size;
	
	// set this image to the UIImageView on the right
	[self.rightView setImage:imageWithTransparentBorder];
	
	// Adjust its size to the new dimensions (it will appear as the same size because the extra points are transparent edges)
	[self.rightView setBounds:(CGRect){CGPointZero, imageSize}];
	
	// remember bounds of each view for later, to use when handling rotation
	[self setLeftBounds:self.leftView.bounds];
	[self setRightBounds:self.rightView.bounds];
	
	// right view doesn't need antialiasing (in case we enable the UIViewEdgeAntialiasing flag in info.plist, otherwise has no effect)
	[self.rightView.layer setEdgeAntialiasingMask:0];
}

- (void)viewDidUnload
{
	[self setLeftView:nil];
	[self setRightView:nil];
    [self setPlayButton:nil];
	[self setLeftLabel:nil];
	[self setRightLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	self.leftView.bounds = self.leftBounds;
	self.rightView.bounds = self.rightBounds;

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		CGSize size = self.view.bounds.size;
		
		if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		{
			self.leftView.center = CGPointMake(size.width / 4, size.height / 2);
			self.rightView.center = CGPointMake(size.width * 3 / 4, size.height / 2);
			
			CGFloat labelHeight = (size.height / 2) + (self.leftBounds.size.height / 2) + LABEL_GAP + (self.leftLabel.bounds.size.height / 2);
			self.leftLabel.center = CGPointMake(size.width / 4, labelHeight);
			self.rightLabel.center = CGPointMake(size.width * 3 / 4, labelHeight);
		}
		else
		{
			self.leftView.center = CGPointMake(size.width / 2, size.height / 4);
			self.rightView.center = CGPointMake(size.width / 2, size.height * 3 / 4);
			
			CGFloat labelHeightOffset = (self.leftBounds.size.height / 2) + LABEL_GAP + (self.leftLabel.bounds.size.height / 2);
			self.leftLabel.center = CGPointMake(size.width / 2, (size.height / 4) + labelHeightOffset);
			self.rightLabel.center = CGPointMake(size.width / 2, (size.height * 3 / 4) + labelHeightOffset);
		}
	}	
}

- (IBAction)playPausePressed:(id)sender {
	
	if (![self isSpinning])
	{
		[self rotateView:self.leftView];
		[self rotateView:self.rightView];
		[self setSpinning:YES];
		
		// swap out button
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed:)];
	}
	else
	{
		[self stopRotation:self.leftView];
		[self stopRotation:self.rightView];
		[self setSpinning:NO];
		
		// swap out button
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPausePressed:)];
	}
}

- (void)rotateView:(UIView *)view
{
	CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.duration = 20;
	animation.repeatCount = 10000;
	animation.fromValue = [NSNumber numberWithDouble:radians(0)];
	animation.toValue = [NSNumber numberWithDouble:radians(360)];
	animation.additive = YES;
	animation.fillMode = kCAFillModeForwards;
	[view.layer addAnimation:animation forKey:@"spin"];
}

- (void)stopRotation:(UIView *)view
{
	CALayer *presentation = [view.layer presentationLayer];
	CATransform3D transform = [presentation transform];
	[view.layer removeAnimationForKey:@"spin"];
	view.layer.transform = transform;
}

@end
