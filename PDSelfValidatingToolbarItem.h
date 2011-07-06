//
//  PDSelfEnablingToolbarItem.h
//  SproutedInterface
//
//  Created by Philip Dow on 12/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDSelfValidatingToolbarItem : NSToolbarItem {
	
	BOOL forcedEnabled;
	BOOL forcedEnabling;
}

- (BOOL) forcedEnabled;
- (void) setForcedEnabled:(BOOL)doEnable;

- (BOOL) forcedEnabling;
- (void) setForcedEnabling:(BOOL)doForce;

@end
