//
//  PDOutlineView.h
//  SproutedInterface
//
//  Created by Philip Dow on 2/1/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDOutlineView : NSOutlineView {

}

@end

@interface NSObject (PDOutlineViewDelegate)

- (void) outlineView:(NSOutlineView*)anOutlineView leftNavigationEvent:(NSEvent*)anEvent;
- (void) outlineView:(NSOutlineView*)anOutlineView rightNavigationEvent:(NSEvent*)anEvent;

@end