//
//  ELUHeroesTableViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/5/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesTableViewController.h"
#import "ELUHeroesModel.h"
#import "eluUtil.h"

#define kNumColumnsPerCategory 4

static const NSString *kAttrPrefix = @"DOTA_Hero_Selection_";
static const NSString *kStrengthString = @"STR";
static const NSString *kAgilityString = @"AGI";
static const NSString *kIntelligenceString = @"INT";
static const NSString *kStrIconFile = @"overviewicon_str.png";
static const NSString *kAgiIconFile = @"overviewicon_agi.png";
static const NSString *kIntIconFile = @"overviewicon_int.png";

@interface ELUHeroesTableViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *heroImageViews;
@property (strong, nonatomic) UIImageView *strImageView;
@property (strong, nonatomic) UIImageView *agiImageView;
@property (strong, nonatomic) UIImageView *intImageView;
@property (strong, nonatomic) UILabel *strLabel;
@property (strong, nonatomic) UILabel *agiLabel;
@property (strong, nonatomic) UILabel *intLabel;

@property (strong, nonatomic) ELUHeroesModel *heroesModel;

@end

@implementation ELUHeroesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.heroesModel = [ELUHeroesModel sharedInstance];
    self.strLabel = [[UILabel alloc] init];
    self.agiLabel = [[UILabel alloc] init];
    self.intLabel = [[UILabel alloc] init];
    self.strImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString*)kStrIconFile]];
    self.agiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString*)kAgiIconFile]];
    self.intImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString*)kIntIconFile]];
    
    NSDictionary *dotaStrings = [eluUtil dotaStrings];
    self.strLabel.text = dotaStrings[[NSString stringWithFormat:@"%@%@", kAttrPrefix, kStrengthString]];
    self.agiLabel.text = dotaStrings[[NSString stringWithFormat:@"%@%@", kAttrPrefix, kAgilityString]];
    self.intLabel.text = dotaStrings[[NSString stringWithFormat:@"%@%@", kAttrPrefix, kIntelligenceString]];
}

@end
