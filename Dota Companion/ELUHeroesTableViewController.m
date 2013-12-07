//
//  ELUHeroesTableViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/5/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesTableViewController.h"
#import "ELUHeroViewController.h"
#import "ELUHeroesModel.h"
#import "ELUHero.h"
#import "AsyncImageView.h"

#import <objc/runtime.h>

#define kNumColumnsPerCategory 4
#define kThumbWidth 59
#define kThumbHeight 33
#define kPadding 5.0
#define kHeaderSize 50.0
#define kCategoryPadding 15.0

static const NSInteger kCategoryWidth = kPadding * (kNumColumnsPerCategory - 1) + kThumbWidth * kNumColumnsPerCategory;

static const NSString *kIconPrefix = @"overviewicon_";

@interface ELUHeroesTableViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *heroImageViews;
@property (strong, nonatomic) ELUHeroesModel *heroesModel;

@property (strong, nonatomic) ELUHero *heroTapped;

@end

@implementation ELUHeroesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.heroesModel = [ELUHeroesModel sharedInstance];
    self.heroTapped = nil;
    
    [self fillHeroImageViews];
    [self.scrollView addSubview:self.heroImageViews];
    self.scrollView.contentSize = self.heroImageViews.frame.size;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)checkOrientation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    if([segueId isEqualToString:@"LandscapeHeroSegue"]) {
        ELUHeroViewController *viewController = segue.destinationViewController;
        viewController.hero = self.heroTapped;
        viewController.onCompletion = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
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
                
                heroImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heroImageTapped:)];
                tapRecognizer.numberOfTapsRequired = 1;
                objc_setAssociatedObject(tapRecognizer, @"hero", hero, OBJC_ASSOCIATION_ASSIGN);
                [heroImageView addGestureRecognizer:tapRecognizer];
                
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
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@", kIconPrefix, [[attribute substringToIndex:3] lowercaseString], @".png"];
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

- (void) heroImageTapped:(UITapGestureRecognizer *) gestureRecognizer {
    self.heroTapped = objc_getAssociatedObject(gestureRecognizer, @"hero");
    [self performSegueWithIdentifier:@"LandscapeHeroSegue" sender:self];
}

@end
