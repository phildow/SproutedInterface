//
//  PDFavoritesBar.h
//  SproutedInterface
//
//  Created by Philip Dow on 3/17/06.
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

#define PDFavoritePboardType				@"PDFavoritePboardType"
#define PDFavoritesDidChangeNotification	@"PDFavoritesDidChangeNotification"

#define	PDFavoriteName	@"name"
#define PDFavoriteID	@"id"

#import <Cocoa/Cocoa.h>

@class PDFavorite;

@interface PDFavoritesBar : NSView {
	
	NSColor			*_backgroundColor;
	NSMutableArray	*_favorites;
	NSMutableArray	*_vFavorites;
	NSMutableArray	*_trackingRects;
	
	NSPopUpButton	*_morePop;
	NSMenuItem		*_popTitle;
	
	unsigned	_eventFavorite;
	BOOL		_titleSheet;
	
	id		delegate;
	id		_target;
	SEL		_action;
	
	NSMenu *contextMenu;
	
	BOOL drawsLabels;
}

- (NSColor*) backgroundColor;
- (void) setBackgroundColor:(NSColor*)color;

- (NSMutableArray*) favorites;
- (void) setFavorites:(NSArray*)favorites;

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (id) target;
- (void) setTarget:(id)target;

- (SEL) action;
- (void) setAction:(SEL)action;

- (BOOL) drawsLabels;
- (void) setDrawsLabels:(BOOL)draws;

- (IBAction) toggleDrawsLabels:(id)sender;

- (void) sendEvent:(unsigned)sender;
- (NSDictionary*) eventFavorite;

- (BOOL) addFavorite:(NSDictionary*)aFavorite atIndex:(unsigned)loc requestTitle:(BOOL)showSheet;
- (void) removeFavoriteAtIndex:(unsigned)loc;

- (void) _generateFavoriteViews:(id)object;
- (void) _positionFavoriteViews:(id)object;

- (void) _initiateDragOperation:(unsigned)favoriteIndex location:(NSPoint)dragStart event:(NSEvent*)theEvent;

- (void) favoritesDidChange:(NSNotification*)aNotification;
- (void) _toolbarDidChangeVisible:(NSNotification*)aNotification;

- (NSString*) _titleFromTitleSheet:(NSString*)defaultTitle;
- (void) _okaySheet:(id)sender;
- (void) _cancelSheet:(id)sender;

- (PDFavorite*) favoriteWithIdentifier:(id)anIdentifier;
- (void) setLabel:(int)label forFavorite:(PDFavorite*)aFavorite;
- (void) rescanLabels;

- (NSRect) frameOfFavoriteAtIndex:(int)theIndex;

@end

@interface NSObject (FavoritesBarDelegate)

- (int) favoritesBar:(PDFavoritesBar*)aFavoritesBar labelOfItemWithIdentifier:(NSString*)anIdentifier;

@end
