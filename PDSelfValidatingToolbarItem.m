//
//  PDSelfEnablingToolbarItem.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDSelfValidatingToolbarItem.h>


@implementation PDSelfValidatingToolbarItem

- (BOOL) forcedEnabled
{
	return forcedEnabled;
}

- (void) setForcedEnabled:(BOOL)doEnable
{
	forcedEnabled = doEnable;
	//[self validate];
}

- (BOOL) forcedEnabling
{
	return forcedEnabling;
}

- (void) setForcedEnabling:(BOOL)doForce
{
	forcedEnabling = doForce;
}

#pragma mark -

- (void)validate 
{
	[self setEnabled:( [self forcedEnabling] ? [self forcedEnabled] : ( [NSApp targetForAction:[self action]] != nil ) )];
}

@end
