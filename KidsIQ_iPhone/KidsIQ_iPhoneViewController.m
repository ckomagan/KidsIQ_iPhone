//
//  KidsIQ_iPhoneViewController.m
//  KidsIQ_iPhone
//
//  Created by Chan Komagan on 9/11/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import "KidsIQ_iPhoneViewController.h"
#import "ResultController.h"
#import "NameViewController.h"
#import "QuitController.h"
#import "QuartzCore/QuartzCore.h"

@interface KidsIQ_iPhoneViewController ()
@property (nonatomic, strong) NSString *nsURL;
@property (nonatomic, strong) NSString *selectedChoice;
@property (nonatomic, strong) NSString *correctChoice;
@end

@interface UIButton (ColoredBackground)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIColor *) silverColor;

@end

@implementation KidsIQ_iPhoneViewController

@synthesize nsURL = _nsURL;
@synthesize responseData;
@synthesize selectedChoice = _selectedChoice;
@synthesize correctChoice = _correctChoice;
@synthesize usedNumbers;
@synthesize mainTimer;
NSInteger _id = -1;
NSInteger _score = 0;
NSInteger _noOfQuestions = 1;
int count = 1;
NSDictionary *res;
NSString *titleText;
NSString *scoreText;
NSString *finalScoreText;
NSString *btnPressed;
bool reset;
int counter;
int hours, minutes, seconds;
int secondsLeft;
int noOfSecs;

@synthesize name;
@synthesize level;
@synthesize maxQuestions;
@synthesize myCounterLabel;

-(void)showLoginViewController {
    
    nameLabel.text = name;
}

-(IBAction)showModalViewController {
    QuitController *tempView = [[QuitController alloc] initWithNibName:@"QuitController" bundle:nil];
    tempView.mainTimer = mainTimer;
    [self presentModalViewController:tempView animated:true];
}

- (void)showbutton {
    submit.enabled = TRUE;
    [submit setTitle: @"Submit" forState: UIControlStateNormal];
	[submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[submit setBackgroundColor:[UIColor brownColor]];
}

- (IBAction)choicea:(id)sender {
    
    [self resetAllChoices];
    choicea = (UIButton *)sender;
    [answerA setTextColor:[UIColor blueColor]];
    [choicea setBackgroundColor:[UIColor blueColor]];
    _selectedChoice = answerA.text;
	btnPressed = @"choicea";
    [self showbutton];
}

- (IBAction)choiceb:(id)sender {
	
    [self resetAllChoices];
    choiceb = (UIButton *)sender;
    [answerB setTextColor:[UIColor blueColor]];
    [choiceb setBackgroundColor:[UIColor blueColor]];
    _selectedChoice = answerB.text;
	btnPressed = @"choiceb";
    [self showbutton];
    
}

- (IBAction)choicec:(id)sender {
    
    [self resetAllChoices];
    choicec = (UIButton *)sender;
    [answerC setTextColor:[UIColor blueColor]];
    [choicec setBackgroundColor:[UIColor blueColor]];
    _selectedChoice = answerC.text;
	btnPressed = @"choicec";
    [self showbutton];
}

- (IBAction)choiced:(id)sender {
    
    [self resetAllChoices];
    choiced = (UIButton *)sender;
    [answerD setTextColor:[UIColor blueColor]];
    [choiced setBackgroundColor:[UIColor blueColor]];
    _selectedChoice = answerD.text;
	btnPressed = @"choiced";
    [self showbutton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    hours = minutes = seconds = 0;
    if ( [mainTimer isValid]){
        [mainTimer invalidate], mainTimer=nil;
    }
    mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(advanceTimer:)
                                               userInfo:nil
                                                repeats:YES];
    

    while(_id < 0)
    {
        _id = [self generateRandomNumber];
    }
    
	if(_noOfQuestions <= maxQuestions)
	{
		submit.enabled = FALSE;
		[submit setTitle: @"Select" forState: UIControlStateNormal];
		[submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[submit setBackgroundColor:[UIColor darkGrayColor]];
        
		_nsURL = [@"http://www.komagan.com/KidsIQ/index.php?format=json&quiz=1&question_id=" stringByAppendingFormat:@"%d ", _id];
        
		//NSLog(@"URL=%@",_nsURL);
        
		self.responseData = [NSMutableData data];
		
		NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: _nsURL]];
		//NSLog(@"request established");
		//NSLog(@"didReceiveResponse");
		[[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
        
	}
	else{
		[self showResults];
        return;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError");
    //NSLog(@"Connection failed: %@", [error description]);
    self.responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    NSError *myError = nil;
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    
    for(NSDictionary *res1 in res) {
        NSString *preText = [NSString stringWithFormat:@"%d", _noOfQuestions];
        preText = [preText stringByAppendingFormat:@") "];
        question.text = [preText stringByAppendingString:[res1 objectForKey:@"question"]];
        NSString *answer = [res1 objectForKey:@"choice_text"];
        [answers addObject :answer];
        
        NSString *rightChoice = [res1 objectForKey:@"is_right_choice"];
        
        if ([rightChoice isEqualToString:@"1"]) {
            _correctChoice = answer;
        }
    }
    
    if ([res count] ==0)
    {
        [self showResults];
        return;
    }
    
    answerA.text = [answers objectAtIndex:0];
    answerB.text = [answers objectAtIndex:1];
    answerC.text = [answers objectAtIndex:2];
    answerD.text = [answers objectAtIndex:3];
	[self calculatescore];
}

- (void)resetAllChoices
{
    [answerA setTextColor:[UIColor blackColor]];
    [choicea setBackgroundColor:[UIColor blackColor]];
    [answerB setTextColor:[UIColor blackColor]];
    [choiceb setBackgroundColor:[UIColor blackColor]];
    [answerC setTextColor:[UIColor blackColor]];
    [choicec setBackgroundColor:[UIColor blackColor]];
    [answerD setTextColor:[UIColor blackColor]];
    [choiced setBackgroundColor:[UIColor blackColor]];
    choicea.enabled = YES;
    choiceb.enabled = YES;
    choiceb.enabled = YES;
    choiced.enabled = YES;
}

- (void)resetAll /* restart the quiz */
{
    _id = 1;
    _score = 0;
    reset = YES;  //reset the first set of questions
    _noOfQuestions = 1;
    [self setCounter];
    [mainTimer invalidate];
    [self viewDidLoad];
}

- (void)disableAllChoices
{
    for (UIView *view in self.view.subviews){
		view.userInteractionEnabled = NO;
		self->submit.userInteractionEnabled = YES;
	}
}

- (void)enableAllChoices
{
    for (UIView *view in self.view.subviews)
		view.userInteractionEnabled=YES;
}

- (IBAction)checkAnswer
{
    if([submit.titleLabel.text isEqual:@"Submit"])
    {
        if ([_selectedChoice isEqualToString:_correctChoice]) {
            result.text = @"Correct Answer!";
            [result setTextColor:[UIColor greenColor]];
			[self highlightChoice];
            _score++;
        }
        else {
			NSString *preText = @"Incorrect! The correct answer is ";
            result.text = [preText stringByAppendingString:[NSString stringWithFormat:@"%@",_correctChoice]];
            [result setTextColor:[UIColor redColor]];
        }
        _noOfQuestions++;
        //_id++;
        _id = [self generateRandomNumber];
        [submit setTitle:@"Next" forState:(UIControlState)UIControlStateNormal];
		[submit setBackgroundColor:[UIColor purpleColor]];
		[submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self disableAllChoices];
        return;
    }
    
    if([submit.titleLabel.text isEqual:@"Next"])
    {
        result.text = @"";
        [self resetAllChoices];
        [self enableAllChoices];
        [self trackScore];
        [mainTimer invalidate];
        [self viewDidLoad];
    }

}

- (IBAction)skipQuestion
{
    _id = [self generateRandomNumber];
    _noOfQuestions++;
    [self resetAllChoices];
    [self trackScore];
	result.text =@"";
    [mainTimer invalidate];
    [self viewDidLoad];
}

- (void)trackScore
{
    scoreText = [NSString stringWithFormat:@"%d",_score];
    scoreText = [scoreText stringByAppendingString:@ "/"];
    scoreText = [scoreText stringByAppendingString:[NSString stringWithFormat:@"%d",maxQuestions]];
    [score setText: scoreText];
}

- (void)calculatescore
{
    float tally;
    if (_noOfQuestions > 0)
    {
        tally = (float)_score / (float)maxQuestions;
        tally = roundf (tally * 100) / 100.0;
        
        if(tally > 0.90)
        {
            titleText = @"You are practically a genius.";
        }
        if((tally > 0.70) && (tally <= 0.90))
        {
            titleText = @"That's great score!";
        }
        if((tally > 0.49) && (tally <= 0.70))
        {
            titleText = @"I think you can do better?!?";
        }
        if(tally <= 0.49)
        {
            titleText = @"You better start over.";
        }
    }
    finalScoreText = [NSString stringWithFormat:@"%.0f", round(tally*100)];
    finalScoreText = [finalScoreText stringByAppendingString: @"%"];
}

-(void)highlightChoice
{
	if([btnPressed isEqual:@"choicea"])
	{
		[choicea setBackgroundColor:[UIColor greenColor]];
		[answerA setTextColor:[UIColor greenColor]];
	}
	
	if([btnPressed isEqual:@"choiceb"])
	{
		[choiceb setBackgroundColor:[UIColor greenColor]];
		[answerB setTextColor:[UIColor greenColor]];
	}
    
	if([btnPressed isEqual:@"choicec"])
	{
		[choicec setBackgroundColor:[UIColor greenColor]];
		[answerC setTextColor:[UIColor greenColor]];
	}
    
	if([btnPressed isEqualToString:@"choiced"])
	{
		[choiced setBackgroundColor:[UIColor greenColor]];
		[answerD setTextColor:[UIColor greenColor]];
	}
}

-(void)showResults
{
    ResultController *resultView = [[ResultController alloc] initWithNibName:@"ResultController" bundle:nil];
    resultView.name = [@"Hi there " stringByAppendingString:[name stringByAppendingString:@""]];
    resultView.titleText = titleText;
    resultView.score = finalScoreText;
	resultView.maxQuestions = maxQuestions;
	[self resetAll];
    resultView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [mainTimer invalidate];
    [self presentModalViewController:resultView animated:true];
}

-(int)generateRandomNumber
{
    int randomNumber = -1;
    randomNumber = (arc4random() % 65)+1;
    //NSLog(@"numberWithSet : %@ \n\n",usedNumbers);
    bool myIndex = [usedNumbers containsObject:[NSNumber numberWithInt: randomNumber]];
    if (myIndex == false)
    {
        [usedNumbers addObject:[NSNumber numberWithInt:randomNumber]];
        count++;
        return randomNumber;
    }
    else{
        NSLog(@"number already there : %d", randomNumber);
        return -1;
    }
    return randomNumber;
}

- (void)setCounter
{
    if(level == 1) noOfSecs = 10; //basic
    if(level == 2) noOfSecs = 7; //intermediate
    if(level == 3) noOfSecs = 5; //advanced
    counter = (maxQuestions*noOfSecs)+1;
    NSLog(@"total secs = %d", counter);
}

- (void)advanceTimer:(NSTimer *)timer
{
    counter--;
    if (counter <= 0) { [timer invalidate]; [self showResults];}
    
    if(counter > 0 ){
        minutes = (counter % 3600) / 60;
        seconds = (counter %3600) % 60;
        myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else{
        counter = 16925;
    }
}

- (void)viewDidUnload
{
    [mainTimer invalidate];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    nameLabel.text = name;
    usedNumbers = [NSMutableSet setWithCapacity:maxQuestions];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ResultControllerScreen"]) {
        
    }
}

-(IBAction)dismissView {
    [mainTimer invalidate];
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation != UIDeviceOrientationLandscapeLeft) &&
	(orientation != UIDeviceOrientationLandscapeRight);
}

@end
