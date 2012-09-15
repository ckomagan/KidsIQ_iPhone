//
//  KidsIQ_iPhoneViewController.h
//  KidsIQ_iPhone
//
//  Created by Chan Komagan on 9/11/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KidsIQ_iPhoneViewController : UIViewController
{
    IBOutlet UILabel *question;
    IBOutlet UILabel *answerA;
    IBOutlet UILabel *answerB;
    IBOutlet UILabel *answerC;
    IBOutlet UILabel *answerD;
    IBOutlet UILabel *myCounterLabel;
    IBOutlet UIButton *choicea;
    IBOutlet UIButton *choiceb;
    IBOutlet UIButton *choicec;
    IBOutlet UIButton *choiced;
    IBOutlet UIButton *submit;
    IBOutlet UILabel *score;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *result;
    IBOutlet UIButton *test;
    NSMutableData *responseData;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableSet *usedNumbers;
@property (nonatomic, retain) UILabel *myCounterLabel;
@property int maxQuestions;
@property (assign) int level;

-(IBAction)showModalViewController;

-(IBAction)showLoginViewController;

-(IBAction)submit:(id)sender;

-(void)resetAllChoices;

-(void)resetAll;

- (void)disableAllChoices;

-(IBAction)checkAnswer;

-(IBAction)skipQuestion;

-(void)calculatescore;

-(void)showResults;

-(int)generateRandomNumber;

-(IBAction)dismissView;

- (IBAction)startCountdown:(id)sender;

@end
