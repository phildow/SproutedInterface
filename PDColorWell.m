//
//  PDColorWell.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDColorWell.h>

@implementation PDColorWell

- (void)activate:(BOOL)exclusive {
	[[self window] makeFirstResponder:self];
	[super activate:YES];
}

@end
