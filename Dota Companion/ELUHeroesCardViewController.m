//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesCardViewController.h"
#import "ELUHeroViewController.h"
#import "ELUHeroesModel.h"
#import "ELUCardView.h"

#import <QuartzCore/QuartzCore.h>

#define kMainCardWidth 0.7
#define kMainCardHeight 0.7
#define kSideCardWidth 0.5
#define kSideCardHeight 0.5
#define kSideCardPadding 50

@interface ELUHeroesCardViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property (strong, nonatomic) NSMutableArray *cardViews;

@property NSUInteger currentHero;
@property NSInteger curCard;

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation ELUHeroesCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentHero = 0;
    self.heroesModel = [ELUHeroesModel sharedInstance];
    
    self.cardViews = [NSMutableArray arrayWithCapacity:5];
    [self.cardViews addObject:[[ELUCardView alloc] initWithFrame:self.view.bounds]];
    [self.cardViews addObject:[[ELUCardView alloc] initWithFrame:self.view.bounds]];
    
    for(int i = 0; i < 3; i++) {
        ELUCardView *cardView = [[ELUCardView alloc] initWithFrame:self.view.bounds];
        [cardView setupWithHero:[self.heroesModel heroAtIndex:i]];
        cardView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
        gestureRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:gestureRecognizer];
        
        [self.cardViews addObject:cardView];
    }
    
    [self.view addSubview:self.cardViews[0]];
    [self.view addSubview:self.cardViews[4]];
    [self.view addSubview:self.cardViews[1]];
    [self.view addSubview:self.cardViews[3]];
    [self.view addSubview:self.cardViews[2]];
    
    {
        ELUCardView *cardView = self.cardViews[0];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(0, self.view.bounds.size.height/2.0);
    }
    
    {
        ELUCardView *cardView = self.cardViews[1];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(kSideCardPadding, self.view.bounds.size.height/2.0);
    }
    
    {
        ELUCardView *cardView = self.cardViews[2];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kMainCardWidth, kMainCardHeight);
        cardView.transform = scaleTransform;
    }
    
    {
        ELUCardView *cardView = self.cardViews[3];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(self.view.bounds.size.width - kSideCardPadding, self.view.bounds.size.height/2.0);
    }
    
    {
        ELUCardView *cardView = self.cardViews[4];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height/2.0);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)checkOrientation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        [self performSegueWithIdentifier:@"OrientationChangeSegue" sender:self];
    }
}

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender {
    self.currentHero++;
    
    ELUCardView *tempCardView = self.cardViews[0];
    CGAffineTransform tempTransform = [(UIView*)self.cardViews[0] transform];
    CGRect tempFrame = [(UIView*)self.cardViews[0] frame];
    for (int i = 1; i < self.cardViews.count; i++) {
        ELUCardView *cardView = self.cardViews[i];
        CGAffineTransform swapTransform = cardView.transform;
        CGRect swapFrame = cardView.frame;
        cardView.transform = tempTransform;
        cardView.frame = tempFrame;
        tempTransform = swapTransform;
        tempFrame = swapFrame;
        self.cardViews[i-1] = cardView;
    }
    
    tempCardView.transform = tempTransform;
    tempCardView.frame = tempFrame;
    self.cardViews[4] = tempCardView;
    
    [self.view bringSubviewToFront:self.cardViews[0]];
    [self.view bringSubviewToFront:self.cardViews[4]];
    [self.view bringSubviewToFront:self.cardViews[1]];
    [self.view bringSubviewToFront:self.cardViews[3]];
    [self.view bringSubviewToFront:self.cardViews[2]];
    
    [self.cardViews[4] setupWithHero:[self.heroesModel heroAtIndex:self.currentHero+2]];
}

- (void) cardTapped {
    [self performSegueWithIdentifier:@"PortraitHeroSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    if([segueId isEqualToString:@"PortraitHeroSegue"]) {
        ELUHeroViewController *viewController = segue.destinationViewController;
        viewController.hero = [self.heroesModel heroAtIndex:self.currentHero];
        viewController.onCompletion = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}
@end
