//
//  ResultController.h
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultController : UIViewController
{
    IBOutlet UILabel *responseText;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIButton *startoverBtn;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *score;
@property int maxQuestions;

-(IBAction)dismissView;
-(IBAction)loginScreen;

@end
