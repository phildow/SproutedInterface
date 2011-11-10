
//
//  NewMediabarItemController.h
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

@class JournlerGradientView;
@class MediabarItemApplicationPicker;

@interface NewMediabarItemController : NSWindowController
{
    IBOutlet MediabarItemApplicationPicker *applicationField;
    IBOutlet NSTextView *scriptText;
	IBOutlet NSTextField *titleField;
	
	IBOutlet NSTextField *appnameField;
	IBOutlet NSImageView *appImageView;
	
	IBOutlet NSObjectController *objectController;
	
	BOOL isSheet;
	NSRect sheetFrame;
	
	id delegate;
	NSWindow *targetWindow;
	
	NSImage *icon;
	NSString *title;
	NSString *helptip;
	NSString *filepath;
	NSAttributedString *scriptSource;
	
	id representedObject;
	
	BOOL wantsScript;
	BOOL wantsFile;
}

- (id) initWithDictionaryRepresentation:(NSDictionary*)aDictionary;
- (NSDictionary*) dictionaryRepresentation;

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (NSImage *)icon;
- (void) setIcon:(NSImage*)anImage;

- (NSString *)title;
- (void) setTitle:(NSString*)aString;

- (NSString *)helptip;
- (void) setHelptip:(NSString*)aString;

- (NSString *)filepath;
- (void) setFilepath:(NSString*)aString;

- (NSAttributedString *)scriptSource;
- (void) setScriptSource:(NSAttributedString*)anAttributedString;

- (id) representedObject;
- (void) setRepresentedObject:(id)anObject;

- (BOOL) wantsScript;
- (void) setWantsScript:(BOOL)aBool;

- (BOOL) wantsFile;
- (void) setWantsFile:(BOOL)aBool;

- (IBAction)cancel:(id)sender;
- (IBAction)chooseApplication:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction) verifyDraggedImage:(id)sender;

- (void) runAsSheetForWindow:(NSWindow*)window attached:(BOOL)sheet location:(NSRect)frame;
- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo;

@end

@interface NSObject (MediaBarItemCreatorDelegate)

- (void) mediabarItemCreateDidCancelAction:(NewMediabarItemController*)mediabarItemCreator;
- (void) mediabarItemCreateDidSaveAction:(NewMediabarItemController*)mediabarItemCreator;

@end