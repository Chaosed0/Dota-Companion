//
//  UILabel+Appearance.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/10/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

//This category gets around the fact that UILabel has no methods marked
// with UI_APPEARANCE_SELECTOR.

#import "UILabel+Appearance.h"

@implementation UILabel (Appearance)

-(void)setTextColorAppearance:(UIColor *)textColor {
    self.textColor = textColor;
}

-(void)setBackgroundColorAppearance:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
}

@end
