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
    //Get some stuff and put it in temp vars
    NSArray *attributes = [ELUConstants sharedInstance].attributes;
    NSArray *teams = [ELUConstants sharedInstance].teams;
    //Width of one category (strength, agi, int)
    const NSInteger categoryWidth = kPadding * (kNumColumnsPerCategory - 1) + kThumbWidth * kNumColumnsPerCategory;
    
    //Maximum point reached in either dimension
    CGPoint maxPoint = CGPointMake(0, 0);
    //Number of category borders placed in each direction
    CGPoint categoryBorders = CGPointMake(0, 0);
    //Current y position
    NSInteger curY = 0;
    
    for(NSString *team in teams) {
        CGPoint curPoint = CGPointMake(0, curY);
        //Strength is first, then agi, then int
        NSInteger attrCounter = 0;
        for(NSString *primaryAttribute in attributes) {
            for(ELUHero *hero in [self.heroDelegate heroesForTeam:team primaryAttribute:primaryAttribute]) {
                //Create a new image view for each hero
                AsyncImageView *heroImageView = [[AsyncImageView alloc] init];
                
                //Use a higher resolution image if the device is a retina display
                if([eluUtil deviceIsRetina]) {
                    heroImageView.imageURL = hero.imageUrlMedium;
                } else {
                    heroImageView.imageURL = hero.imageUrlSmall;
                }
                
                //Get the x location and y location to put this image view, depending on
                // the number of category borders, number of images placed, etc
                NSInteger xLocation = kPadding * (curPoint.x + 1 - categoryBorders.x) + kThumbWidth
                * curPoint.x + categoryBorders.x * kCategoryPadding;
                NSInteger yLocation = kPadding * (curPoint.y + 1 - categoryBorders.y) + kHeaderSize + kThumbHeight * curPoint.y + categoryBorders.y * kCategoryPadding;
                //Put the image view down in the right place.
                heroImageView.frame = CGRectMake(xLocation, yLocation, kThumbWidth, kThumbHeight);
                
                //Create a tap gesture recognizer for each image and add an action to it
                heroImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heroImageTapped:)];
                tapRecognizer.numberOfTapsRequired = 1;
                objc_setAssociatedObject(tapRecognizer, @"hero", hero, OBJC_ASSOCIATION_ASSIGN);
                [heroImageView addGestureRecognizer:tapRecognizer];
                
                //Add the image view to the main view
                [heroImageViews addSubview:heroImageView];
                
                //Advance the position
                curPoint.x++;
                if(curPoint.x >= attrCounter*kNumColumnsPerCategory + kNumColumnsPerCategory) {
                    curPoint.x = attrCounter*kNumColumnsPerCategory;
                    curPoint.y++;
                }
            }
            //Update the maximum point, if needed
            maxPoint.x = MAX(maxPoint.x, curPoint.x+1);
            maxPoint.y = MAX(maxPoint.y, curPoint.y+1);
            
            //Update other stuff
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
        //Create a label and an image view
        UILabel *attrLabel = [[UILabel alloc] init];
        attrLabel.text = attribute;
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@", kIconPrefix, [[attribute substringToIndex:3] lowercaseString], @".png"];
        UIImageView *attrImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        attrImage.frame = CGRectMake(0, 0, attrImage.image.size.width, attrImage.image.size.height);
        //Make the label the exact size to fit the text
        [attrLabel sizeToFit];
        //Center the label with respect to the image
        attrLabel.center = CGPointMake(attrImage.frame.size.width + kPadding + attrLabel.frame.size.width/2.0, attrImage.frame.size.height/2.0);
        
        //Create a new UIView to hold the image and label, so it's easier to center
        UIView *attrBox = [[UIView alloc] init];
        [attrBox addSubview:attrImage];
        [attrBox addSubview:attrLabel];
        //Center the holding view above the category it represents
        attrBox.bounds = CGRectMake(0, 0, attrImage.frame.size.width + kPadding + attrLabel.frame.size.width, MAX(attrImage.frame.size.height, attrLabel.frame.size.height));
        attrBox.center = CGPointMake((kCategoryPadding + categoryWidth) * attrCounter + kPadding + categoryWidth/2.0, kPadding + kHeaderSize/2.0);
        
        //Add the holding box and its subviews to the main view
        [heroImageViews addSubview:attrBox];
        attrCounter++;
    }
    
    //Calculate the total width and height of the main view and set the frame
    NSInteger totalWidth = kPadding * 2 + kCategoryPadding * (attributes.count - 1) + categoryWidth * attributes.count;
    NSInteger totalHeight = kPadding * 2 + kCategoryPadding * (teams.count - 1) + kPadding * (maxPoint.y - teams.count) + kThumbHeight * maxPoint.y + kHeaderSize;
    heroImageViews.frame = CGRectMake(0, 0, totalWidth, totalHeight);
    
    return heroImageViews;
}

//Scroll view delegate method for zooming
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.heroImageViews;
}

//Method called when any hero image view is tapped
- (void) heroImageTapped:(UITapGestureRecognizer *) gestureRecognizer {
    [self.heroDelegate heroTapped:(ELUHero*)objc_getAssociatedObject(gestureRecognizer, @"hero")];
}


@end
