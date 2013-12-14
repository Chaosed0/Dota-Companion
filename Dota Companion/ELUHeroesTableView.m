//
//  ELUHeroesTableView.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/13/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "AsyncImageView.h"
#import "ELUHeroesTableView.h"
#import "ELUHeroDelegate.h"
#import "ELUHero.h"

#import <objc/runtime.h>

static const NSString *kIconPrefix = @"overviewicon_";

#define kNumColumnsPerCategory 4
#define kThumbWidth 59
#define kThumbHeight 33
#define kPadding 5.0
#define kHeaderSize 50.0
#define kCategoryPadding 15.0

@interface ELUHeroesTableView ()

@property (strong, nonatomic) UIView *heroImageViews;

@end

@implementation ELUHeroesTableView

- (id)initWithFrame:(CGRect)frame delegate:(id<ELUHeroDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
        self.heroDelegate = delegate;
        
        self.heroImageViews = [self getHeroImageViews];
        [self addSubview:self.heroImageViews];
        self.contentSize = self.heroImageViews.frame.size;
        self.delegate = self;
        
        self.minimumZoomScale = MIN(self.bounds.size.height / self.heroImageViews.bounds.size.width, self.bounds.size.width / self.heroImageViews.bounds.size.height);
        self.maximumZoomScale = 1.0;
        self.zoomScale = self.minimumZoomScale;
    }
    return self;
}

- (UIView*) getHeroImageViews {
    UIView *heroImageViews = [[UIView alloc] init];
    NSArray *attributes = [ELUConstants sharedInstance].attributes;
    NSArray *teams = [ELUConstants sharedInstance].teams;
    
    //const CGSize heroImageSize = CGSizeMake(self.view.bounds.size.height / kThumbWidth, self.view.bounds.size.width / kThumbHeight);
    const NSInteger categoryWidth = kPadding * (kNumColumnsPerCategory - 1) + kThumbWidth * kNumColumnsPerCategory;
    
    CGPoint maxPoint = CGPointMake(0, 0);
    CGPoint categoryBorders = CGPointMake(0, 0);
    NSInteger curY = 0;
    
    for(NSString *team in teams) {
        CGPoint curPoint = CGPointMake(0, curY);
        //Strength is first, then agi, then int
        NSInteger attrCounter = 0;
        for(NSString *primaryAttribute in attributes) {
            for(ELUHero *hero in [self.heroDelegate heroesForTeam:team primaryAttribute:primaryAttribute]) {
                AsyncImageView *heroImageView = [[AsyncImageView alloc] init];
                
                if([eluUtil deviceIsRetina]) {
                    heroImageView.imageURL = hero.imageUrlMedium;
                } else {
                    heroImageView.imageURL = hero.imageUrlSmall;
                }
                
                NSInteger xLocation = kPadding * (curPoint.x + 1 - categoryBorders.x) + kThumbWidth
                * curPoint.x + categoryBorders.x * kCategoryPadding;
                NSInteger yLocation = kPadding * (curPoint.y + 1 - categoryBorders.y) + kHeaderSize + kThumbHeight * curPoint.y + categoryBorders.y * kCategoryPadding;
                heroImageView.frame = CGRectMake(xLocation, yLocation, kThumbWidth, kThumbHeight);
                
                heroImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heroImageTapped:)];
                tapRecognizer.numberOfTapsRequired = 1;
                objc_setAssociatedObject(tapRecognizer, @"hero", hero, OBJC_ASSOCIATION_ASSIGN);
                [heroImageView addGestureRecognizer:tapRecognizer];
                
                [heroImageViews addSubview:heroImageView];
                
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
        attrBox.center = CGPointMake((kCategoryPadding + categoryWidth) * attrCounter + kPadding + categoryWidth/2.0, kPadding + kHeaderSize/2.0);
        
        [heroImageViews addSubview:attrBox];
        attrCounter++;
    }
    
    NSInteger totalWidth = kPadding * 2 + kCategoryPadding * (attributes.count - 1) + categoryWidth * attributes.count;
    NSInteger totalHeight = kPadding * 2 + kCategoryPadding * (teams.count - 1) + kPadding * (maxPoint.y - teams.count) + kThumbHeight * maxPoint.y + kHeaderSize;
    heroImageViews.frame = CGRectMake(0, 0, totalWidth, totalHeight);
    
    return heroImageViews;
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.heroImageViews;
}

- (void) heroImageTapped:(UITapGestureRecognizer *) gestureRecognizer {
    [self.heroDelegate heroTapped:(ELUHero*)objc_getAssociatedObject(gestureRecognizer, @"hero")];
}


@end
