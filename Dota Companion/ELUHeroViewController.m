//
//  ELUHeroViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/6/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroViewController.h"
#import "ELUHero.h"
#import "ELUHeroAbility.h"
#import "AsyncImageView.h"

#define kPadding 5.0

@interface ELUHeroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *abilityImageViews;
@property (weak, nonatomic) IBOutlet AsyncImageView *heroImageView;
- (IBAction)backPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *heroBioTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ELUHeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.heroNameLabel.text = self.hero.name;
    self.heroImageView.imageURL = self.hero.imageUrlLarge;
    for(int i = 0; i < self.abilityImageViews.count; i++) {
        AsyncImageView *imageView = self.abilityImageViews[i];
        ELUHeroAbility *ability = self.hero.abilities[i];
        imageView.imageURL = ability.imageUrlSmall;
    }
    self.heroBioTextView.text = self.hero.bio;
}

-(void)viewWillAppear:(BOOL)animated {
    [self checkOrientation:self.interfaceOrientation];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self checkOrientation:toInterfaceOrientation];
}

- (void)checkOrientation:(UIInterfaceOrientation)orientation {
    CGSize frameSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    NSInteger toolbarHeight = self.toolbar.frame.size.height;
    NSLog(@"%g %g", frameSize.height, frameSize.height - toolbarHeight - kPadding*2);
    [eluUtil logRect:self.view.bounds];
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        NSInteger xPosition = self.heroImageView.frame.origin.x + self.heroImageView.frame.size.width + kPadding;
        self.heroBioTextView.frame = CGRectMake(xPosition, kPadding, frameSize.width - xPosition - kPadding*2, frameSize.height - toolbarHeight - kPadding*2);
    } else if(UIInterfaceOrientationIsPortrait(orientation)) {
        AsyncImageView *abilityView = (AsyncImageView*)self.abilityImageViews[0];
        NSInteger yPosition = abilityView.frame.origin.y + abilityView.frame.size.width + kPadding;
        self.heroBioTextView.frame = CGRectMake(kPadding, yPosition, frameSize.width - kPadding * 2, frameSize.height - yPosition - kPadding*2 - toolbarHeight);
    }
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    self.onCompletion();
}
@end
