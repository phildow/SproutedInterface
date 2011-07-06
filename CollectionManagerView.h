
//
//  CollectionManagerView.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface CollectionManagerView : NSView
{
	BOOL bordered;
	int numConditions;
}

- (int) numConditions;
- (void) setNumConditions:(int)num;

- (BOOL) bordered;
- (void) setBordered:(BOOL)drawsBorder;

@end