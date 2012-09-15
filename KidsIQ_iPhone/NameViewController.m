//
//  NameViewController.m
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import "NameViewController.h"
#import "KidsIQ_iPhoneViewController.h"

@interface NameViewController()
@end

@implementation NameViewController

@synthesize levelpicker;
@synthesize levelPickerView;
@synthesize maxQuestions;

NSString *levelSelection;
int challengeLevel = 1;
int noOfQuestions = 0;
#define LEGAL	@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    challengeLevel = 1; noOfQuestions = 0;
    nameText.delegate = self;
    //noOfQuestions = maxQuestions;
    levelpicker = [NSArray arrayWithObjects:@"60", @"40",@"20",nil];
    levelPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    levelPickerView.delegate = self;
    levelPickerView.showsSelectionIndicator = YES;
    [levelPickerView selectRow:1 inComponent:0 animated:YES];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.2, 1.2);
    [self.levelPickerView setTransform:rotate];
    [self.view addSubview:levelPickerView];
    self.levelPickerView.center = CGPointMake(160,250);
    [nameText setFrame:CGRectMake(50, 130, 200, 40)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [nameOK setEnabled:NO];

}

-(IBAction)validateTextFields:(id)sender
{
    // make sure all fields are have something in them
    if (nameText.text.length  > 0 && nameText.text.length <= 6) {
        nameOK.enabled = YES;
    }
    else {
        nameOK.enabled = NO;
    }
}

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showQuiz"]) {
        KidsIQ_iPhoneViewController *quizView = segue.destinationViewController;
        if ([nameText.text isEqualToString:@""]) {
            errorStatus.text = @"Please enter the name.";
            return;
        }
        
        quizView.name = nameText.text;  
        quizView.maxQuestions = noOfQuestions;
        quizView.level = challengeLevel; //1 is basic
        [quizView resetAll];
    }
    //NSLog(@"%i", noOfQuestions);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 3;
    noOfQuestions = 0;
    return numRows;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    levelSelection = [levelpicker objectAtIndex:row];
    //NSLog(@"You selected: %@", levelSelection);
    noOfQuestions = [levelSelection intValue];
    [nameText resignFirstResponder];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [levelpicker objectAtIndex:row];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LEGAL] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return ([string isEqualToString:filtered] && !([newString length] > 6));
    
    //return !([newString length] > 5);
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [nameText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nameText resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [nameText resignFirstResponder];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [nameText resignFirstResponder];
    CGRect rect = CGRectMake(0, 0, 200, 100);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.25, 2.5);
    [label setTransform:rotate];
    label.text = [levelpicker objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:60.0];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 2;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
    noOfQuestions = 40;
    return label;
}

- (IBAction)valueChanged
{
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:
            challengeLevel = 1;
			break;
		case 1:
            challengeLevel = 2;
			break;
        case 2:
            challengeLevel = 3;
			break;
		default:
            break;
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        titleLabel.center = CGPointMake(230,20);
        nameLabel.center = CGPointMake(230,70);
        [nameText setFrame:CGRectMake(120, 90, 220, 40)];
        choicesLabel.center = CGPointMake(240, 160);
        self.levelPickerView.center = CGPointMake(230,210);
        nameOK.center = CGPointMake(230,270);
    }
    else
    {
        titleLabel.center = CGPointMake(160,43);
        nameLabel.center = CGPointMake(160,97);
        [nameText setFrame:CGRectMake(50, 120, 200, 40)];
        choicesLabel.center = CGPointMake(156, 200);
        self.levelPickerView.center = CGPointMake(160,250);
        nameOK.center = CGPointMake(154,328);
    }
}


@end
