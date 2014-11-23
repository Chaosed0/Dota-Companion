//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesViewController.h"
#import "ELUHeroViewController.h"
#import "ELUHeroesCardView.h"
#import "ELUHeroesTableView.h"
#import "ELUHeroesModel.h"
#import "ELUHeroDelegate.h"
#import "ELUCardView.h"
#import "ELUHero.h"

#import <QuartzCore/QuartzCore.h>

@interface ELUHeroesViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property(strong, nonatomic) ELUHeroesCardView *cardView;
@property(strong, nonatomic) ELUHeroesTableView *tableView;
@property(strong, nonatomic) ELUHero *tappedHero;

@end

@implementation ELUHeroesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.heroesModel = [ELUHeroesModel sharedInstance];
    
    self.cardView = [[ELUHeroesCardView alloc] initWithFrame:self.view.bounds delegate:self];
    self.cardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView = [[ELUHeroesTableView alloc] initWithFrame:self.view.bounds delegate:self];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Check if the orientation is the correct way; it might not be, since rotation
    // might have occured while another view was in focus
    [self checkOrientation:[self interfaceOrientation] Duration:0.0];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //Check what view to display.
    [self checkOrientation:toInterfaceOrientation Duration:duration];
}

//Displays the correct view depending on the orientation of the interface. Animates for
// duration seconds.
- (void)checkOrientation:(UIInterfaceOrientation)orientation Duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:duration animations:^{
            self.cardView.alpha = 0.0;
            self.tableView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.cardView.alpha = 1.0;
            self.tableView.alpha = 0.0;
        }];
    }
}

- (NSArray*)heroesForTeam:(NSString *)team primaryAttribute:(NSString *)primaryAttribute {
    return [self.heroesModel heroesForTeam:team primaryAttribute:primaryAttribute];
}

- (NSInteger)heroCount {
    return [self.heroesModel count];
}

- (ELUHero*) heroForIndex:(NSUInteger)index {
    return [self.heroesModel heroAtIndex:index];
}

- (void) heroTapped:(ELUHero *)hero {
    self.tappedHero = hero;
    [self performSegueWithIdentifier:@"HeroSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    if([segueId isEqualToString:@"HeroSegue"]) {
        ELUHeroViewController *viewController = segue.destinationViewController;
        viewController.hero = self.tappedHero;
        viewController.onCompletion = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}
@end
