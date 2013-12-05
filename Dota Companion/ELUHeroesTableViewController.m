//
//  ELUHeroesTableViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/5/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesTableViewController.h"
#import "ELUHeroesModel.h"
#import "ELUHero.h"
#import "AsyncImageView.h"

#define kNumColumnsPerCategory 4
#define kThumbWidth 59
#define kThumbHeight 33
#define kPadding 5.0

static const NSString *kAttrPrefix = @"DOTA_Hero_Selection_";
static const NSString *kStrIconFile = @"overviewicon_str.png";
static const NSString *kAgiIconFile = @"overviewicon_agi.png";
static const NSString *kIntIconFile = @"overviewicon_int.png";

@interface ELUHeroesTableViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *heroImageViews;

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
    self.intLabel.text = dotaStrings[[NSString stringWithFormat:@"%@%@", kAttrPrefix, kIntellectString]];
    
    [self fillHeroImageViews];
    [self.scrollView addSubview:self.heroImageViews];
    self.scrollView.contentSize = self.heroImageViews.frame.size;
}

- (void) fillHeroImageViews {
    self.heroImageViews = [[UIView alloc] init];
    
    CGPoint maxPoint = CGPointMake(0, 0);
    NSInteger curY = 0;
    
    for(NSString *team in @[kGoodTeamString, kBadTeamString]) {
        CGPoint curPoint = CGPointMake(0, curY);
        //Strength is first, then agi, then int
        NSInteger attrCounter = 0;
        for(NSString *primaryAttribute in @[kStrengthString, kAgilityString, kIntellectString]) {
            for(ELUHero *hero in [self.heroesModel heroesForTeam:team primaryAttribute:primaryAttribute]) {
                AsyncImageView *heroImageView = [[AsyncImageView alloc] init];
                heroImageView.imageURL = hero.image_small_url;
                heroImageView.frame = CGRectMake(kPadding*(curPoint.x+1) + kThumbWidth*curPoint.x, kPadding*(curPoint.y +1) + kThumbHeight*curPoint.y, kThumbWidth, kThumbHeight);
                [self.heroImageViews addSubview:heroImageView];
                curPoint.x++;
                if(curPoint.x >= attrCounter*kNumColumnsPerCategory + kNumColumnsPerCategory) {
                    curPoint.x = attrCounter*kNumColumnsPerCategory;
                    curPoint.y++;
                }
            }
            maxPoint.x = MAX(maxPoint.x, curPoint.x+1);
            maxPoint.y = MAX(maxPoint.y, curPoint.y+1);
            attrCounter++;
            curPoint.x = attrCounter*kNumColumnsPerCategory;
            curPoint.y = curY;
        }
        curY += maxPoint.y;
    }
    
    self.heroImageViews.frame = CGRectMake(0, 0, kPadding * (maxPoint.x + 2) + kThumbWidth * (maxPoint.x), kPadding * (maxPoint.y + 2) + kThumbHeight * (maxPoint.y));
}

@end
