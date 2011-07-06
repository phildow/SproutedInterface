//
//  PDDelegatedToolbar.h
//  SproutedInterface
//
//  Created by Philip Dow on 12/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

#define PDToolbarDidShowNotification @"PDToolbarDidShowNotification"
#define PDToolbarDidHideNotification @"PDToolbarDidHideNotification"

@interface PDToolbar : NSToolbar {

}

- (NSToolbarItem*) itemWithTag:(int)aTag;
- (NSToolbarItem*) itemWithIdentifier:(NSString*)identifier;

@end

@interface NSObject (PDToolbarDelegate)

- (void) toolbarDidChangeSizeMode:(PDToolbar*)aToolbar;
- (void) toolbarDidChangeDisplayMode:(PDToolbar*)aToolbar;

- (void) toolbarDidShow:(PDToolbar*)aToolbar;
- (void) toolbarDidHide:(PDToolbar*)aToolbar;

@end