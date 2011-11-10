//
//  PDTabsView.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import <Cocoa/Cocoa.h>

@class PDTabs;

@interface PDTabsView : NSView
{
	int availableWidth;
	int closeDown;
	
	int		_flashingTab;
	int		_malFlash;
	BOOL	_flashing;
	
	int		_tabToSelect;
	int		_targetTabForContext;
	BOOL	_amSwitching;
	
	BOOL	_tabFromTop;
	BOOL drawsShadow;
	
	NSPoint	_lastViewLoc;
	NSDate *_lastStillMoment;

	NSPopUpButton		*morePop;
	NSMenuItem			*popTitle;
	
	NSColor			*backgroundColor;
	
	int lastTabCount;
	int hoverIndex;
	int closeHoverIndex;
	int selectingIndex;
	NSMutableArray *titleTrackingRects;
	NSMutableArray *closeButtonTrackingRects;
	
	NSImage			*tabCloseFront;
	NSImage			*tabCloseFrontDown;
	
	NSImage			*tabCloseBack;
	NSImage			*tabCloseBackDown;
	
	NSImage			*backRollover;
	NSImage			*frontRollover;
	
	int borders[4];
	
	// Jourlner Additions --------------------------
	
	NSImage			*totalImage;
	
	IBOutlet id delegate;
	IBOutlet id dataSource;
	
	NSMenu *contextMenu;
}

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (id) dataSource;
- (void) setDataSource:(id)anObject;

- (int) selectedTab;

#pragma mark -

- (BOOL) tabFromTop;
- (void) setTabFromTop:(BOOL)direction;

- (BOOL) drawsShadow;
- (void) setDrawsShadow:(BOOL)shadow;

- (int*) borders;
- (void) setBorders:(int*)theBorders;

- (int) availableWidth;
- (void) setAvailableWidth:(int)tabWidth;

- (NSColor*) backgroundColor;
- (void) setBackgroundColor:(NSColor*)color;

- (void) handleRegisterDragTypes;
- (void) handleDeregisterDragTypes;

- (void) flashTab:(int)tab;
- (void) flash:(NSTimer*)timer;

- (void) closeTab:(int)tab;
- (void) selectTab:(int)newSelection;

- (IBAction) selectTabByPop:(id)sender;

- (IBAction) newTab:(id)sender;
- (IBAction) closeTargetedTab:(id)sender;
- (IBAction) closeOtherTabs:(id)sender;

- (void) updateTrackingRects;
- (void) _updateTrackingRects:(NSNotification*)aNotification;
- (void) _toolbarDidChangeVisible:(NSNotification*)aNotification;

- (NSRect) frameOfTabAtIndex:(int)theIndex;
- (NSRect) frameOfCloseButtonAtIndex:(int)theIndex;

@end

@interface NSObject (PDTabsDataSource)
	
- (unsigned int) numberOfTabsInTabView:(PDTabsView*)aTabView;
- (unsigned int) selectedTabIndexInTabView:(PDTabsView*)aTabView;
- (NSString*) tabsView:(PDTabsView*)aTabView titleForTabAtIndex:(unsigned int)index;
	
@end

@interface NSObject (PDTabsDelegate)

- (void) tabsView:(PDTabsView*)aTabView removedTabAtIndex:(int)index;
- (void) tabsView:(PDTabsView*)aTabView selectedTabAtIndex:(int)index;

@end
