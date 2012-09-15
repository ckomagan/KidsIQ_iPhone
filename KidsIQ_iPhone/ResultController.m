//
//  ResultController.m
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import "ResultController.h"
#import "KidsIQ_iPhoneViewController.h"
#import "NameViewController.h"

@interface ResultController()
@end

@implementation ResultController
@synthesize name; 
@synthesize titleText;
@synthesize score;
@synthesize maxQuestions;
bool reset = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    nameLabel.text = name;
    titleLabel.text = titleText;
    scoreLabel.text = [@"Your score is: " stringByAppendingString:score];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)dismissView {
    
    KidsIQ_iPhoneViewController *quiView = [[KidsIQ_iPhoneViewController alloc] initWithNibName:@"KidsIQ_iPhoneViewController" bundle:nil];
    [self dismissModalViewControllerAnimated:YES];
    quiView.maxQuestions = maxQuestions;
    [self presentModalViewController:quiView animated:false];
}

-(IBAction)loginScreen {
    
    NameViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"NameViewController"];
    vc.maxQuestions = 0;
    [self presentModalViewController:vc animated:false];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation != UIDeviceOrientationLandscapeLeft) &&
	(orientation != UIDeviceOrientationLandscapeRight);
}

@end
