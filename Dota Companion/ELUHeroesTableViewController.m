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
#define kHeaderSize 50.0
#define kCategoryPadding 15.0

static const NSInteger kCategoryWidth = kPadding * (kNumColumnsPerCategory - 1) + kThumbWidth * kNumColumnsPerCategory;

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
    NSArray *attributes = [ELUConstants sharedInstance].attributes;
    NSArray *teams = [ELUConstants sharedInstance].teams;
    
    CGPoint maxPoint = CGPointMake(0, 0);
    CGPoint categoryBorders = CGPointMake(0, 0);
    NSInteger curY = 0;
    
    for(NSString *team in teams) {
        CGPoint curPoint = CGPointMake(0, curY);
        //Strength is first, then agi, then int
        NSInteger attrCounter = 0;
        for(NSString *primaryAttribute in attributes) {
            for(ELUHero *hero in [self.heroesModel heroesForTeam:team primaryAttribute:primaryAttribute]) {
                AsyncImageView *heroImageView = [[AsyncImageView alloc] init];
                heroImageView.imageURL = hero.image_small_url;
                NSInteger xLocation = kPadding * (curPoint.x + 1 - categoryBorders.x) + kThumbWidth * curPoint.x + categoryBorders.x * kCategoryPadding;
                NSInteger yLocation = kPadding * (curPoint.y + 1 - categoryBorders.y) + kHeaderSize + kThumbHeight * curPoint.y + categoryBorders.y * kCategoryPadding;
                heroImageView.frame = CGRectMake(xLocation, yLocation, kThumbWidth, kThumbHeight);
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
            categoryBorders.x++;
        }
        curY = maxPoint.y;
        categoryBorders.x = 0;
        categoryBorders.y++;
    }

    //Create a label and image for the attribute
    NSInteger attrCounter = 0;
    for (NSString *attribute in attributes) {
        
        UILabel *attrLabel = [[UILabel alloc] init];
        attrLabel.text = attribute;
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@", @"overviewicon_", [[attribute substringToIndex:3] lowercaseString], @".png"];
        UIImageView *attrImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        attrImage.frame = CGRectMake(0, 0, attrImage.image.size.width, attrImage.image.size.height);
        [attrLabel sizeToFit];
        attrLabel.center = CGPointMake(attrImage.frame.size.width + kPadding + attrLabel.frame.size.width/2.0, attrImage.frame.size.height/2.0);
        
        UIView *attrBox = [[UIView alloc] init];
        [attrBox addSubview:attrImage];
        [attrBox addSubview:attrLabel];
        attrBox.bounds = CGRectMake(0, 0, attrImage.frame.size.width + kPadding + attrLabel.frame.size.width, MAX(attrImage.frame.size.height, attrLabel.frame.size.height));
        attrBox.center = CGPointMake((kCategoryPadding + kCategoryWidth) * attrCounter + kPadding + kCategoryWidth/2.0, kPadding + kHeaderSize/2.0);
        
        [self.heroImageViews addSubview:attrBox];
        attrCounter++;
    }
    
    NSInteger totalWidth = kPadding * 2 + kCategoryPadding * (attributes.count - 1) + kCategoryWidth * attributes.count;
    NSInteger totalHeight = kPadding * 2 + kCategoryPadding * (teams.count - 1) + kPadding * (maxPoint.y - teams.count) + kThumbHeight * maxPoint.y + kHeaderSize;
    self.heroImageViews.frame = CGRectMake(0, 0, totalWidth, totalHeight);
}

@end
