//
//  ELUAbilityViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/9/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUAbilityViewController.h"
#import "ELUAbility.h"
#import "AsyncImageView.h"

@interface ELUAbilityViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet AsyncImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *manaCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *cooldownLabel;
@property (weak, nonatomic) IBOutlet UIImageView *manaCostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cooldownImageView;

@end

@implementation ELUAbilityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
    self.title = self.ability.name;
    self.textView.textColor = nil;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.attributedText = [self attributedStringDescription];
    self.imageView.imageURL = self.ability.imageUrlMedium;
    if(self.ability.manaCosts.count > 0 && self.ability.cooldowns.count > 0) {
        self.manaCostLabel.text = [self.ability.manaCosts componentsJoinedByString:@"/"];
        self.manaCostLabel.textColor = [ELUConstants sharedInstance].darkTextColor;
        self.cooldownLabel.text = [self.ability.cooldowns componentsJoinedByString:@"/"];
        self.cooldownLabel.textColor = [ELUConstants sharedInstance].darkTextColor;
    } else {
        self.manaCostLabel.alpha = 0.0;
        self.cooldownLabel.alpha = 0.0;
        self.manaCostImageView.alpha = 0.0;
        self.cooldownImageView.alpha = 0.0;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSAttributedString*)attributedStringDescription {
    NSAttributedString *newline = [[NSAttributedString alloc] initWithString:@"\n"];
    NSDictionary *textColorAttributes = @{NSForegroundColorAttributeName: [ELUConstants sharedInstance].textColor};
    
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:self.ability.simpleDescription attributes:textColorAttributes];
    [description appendAttributedString:newline];
    [description appendAttributedString:newline];
    
    for(NSString* note in self.ability.numericalNotes) {
        NSRange colonLoc = [note rangeOfString:@":"];
        NSMutableAttributedString *attrNote = [[NSMutableAttributedString alloc] initWithString:note attributes:textColorAttributes];
        
        [attrNote addAttribute:NSForegroundColorAttributeName value:[ELUConstants sharedInstance].darkTextColor range:NSMakeRange(colonLoc.location + colonLoc.length, note.length - colonLoc.location - colonLoc.length)];
        [description appendAttributedString:attrNote];
        [description appendAttributedString:newline];
    }
    [description appendAttributedString:newline];
    
    for(NSString* note in self.ability.stringNotes) {
        NSAttributedString *attrNote = [[NSAttributedString alloc] initWithString:note attributes:textColorAttributes];
        [description appendAttributedString:attrNote];
        [description appendAttributedString:newline];
    }
    [description appendAttributedString:newline];
    
    UIFont *italicsFont = [UIFont italicSystemFontOfSize:14];
    NSDictionary *loreAttributes = @{NSFontAttributeName:italicsFont, NSForegroundColorAttributeName: [ELUConstants sharedInstance].textColor};
    NSAttributedString *lore = [[NSAttributedString alloc] initWithString:self.ability.lore attributes:loreAttributes];
    [description appendAttributedString:lore];
    
    return description;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
