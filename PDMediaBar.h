//
//  PDMediaBar.h
//  SproutedInterface
//
//  Created by Philip Dow on 2/21/07.
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
#import <SproutedInterface/JournlerGradientView.h>

typedef enum {
	kMediaBarDefaultItem = 100,
	kMediaBarShowInFinder = 101,
	kMediaBarOpenWithFinder = 102,
	kMediaBarGetInfo = 103
} MediaBarDefaultActions;


@class PDMediabarItem;

@interface PDMediaBar : JournlerGradientView {
	
	id delegate;
	
	NSString *prefsIdentifier;
	NSDictionary *barDictionary;
	NSArray *itemIdentifiers;
	NSArray *customItemDictionaries;
	
	NSArray *itemArray;
}

- (id) delegate;
- (void) setDelegate:(id)anObject;

// the following accessors should not be called - think of them as private

- (NSString*)prefsIdentifier;
- (void) setPrefsIdentifier:(NSString*)aString;

- (NSDictionary*)barDictionary;
- (void) setBarDictionary:(NSDictionary*)aDictionary;

- (NSArray*)itemIdentifiers;
- (void) setItemIdentifiers:(NSArray*)anArray;

- (NSArray*)customItemDictionaries;
- (void) setCustomItemDictionaries:(NSArray*)anArray;

- (NSArray*) itemArray;
- (void) setItemArray:(NSArray*)anArray;

- (void) loadItems;
- (void) displayItems;

- (IBAction) addCustomMediabarItem:(id)sender;
- (IBAction) editCustomMediabarItem:(id)sender;
- (IBAction) removeCustomMediabarItem:(id)sender;

- (void) _removeCustomMediabarItem:(PDMediabarItem*)anItem;
- (void) _editCustomMediabarItem:(PDMediabarItem*)anItem;

- (void) _didChangeFrame:(NSNotification*)aNotification;

@end

@interface NSObject (PDMediaBarDelegate)

//
// for now the media bar only allows buttons
// it begins from the right with the first item returned by preferences

- (void) setupMediabar:(PDMediaBar*)aMediabar url:(NSURL*)aURL;

- (NSImage*) defaultOpenWithFinderImage:(PDMediaBar*)aMediabar;
- (float) mediabarMinimumWidthForUnmanagedControls:(PDMediaBar*)aMediabar;

- (BOOL) canCustomizeMediabar:(PDMediaBar*)aMediabar;
- (NSString*) mediabarIdentifier:(PDMediaBar*)aMediabar;

// the action method for user-defined mediabar items.
// to find out which mediabar the item is associated with, call -mediabar on it
- (IBAction) perfomCustomMediabarItemAction:(PDMediabarItem*)anItem;

// subclasses may override when offering their own default items,
// call super to get support for any standard items you also include
- (PDMediabarItem*) mediabar:(PDMediaBar *)mediabar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoMediabar:(BOOL)flag;

// subclasses should override to provide the default item identifiers
// listing is displayed from the right to the left in the media bar
- (NSArray*) mediabarDefaultItemIdentifiers:(PDMediaBar *)mediabar;

@end
