//
//  MediabarItemApplicationPicker.h
//  SproutedInterface
//
//  Created by Philip Dow on 2/22/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>
#import <SproutedInterface/JournlerGradientView.h>

@interface MediabarItemApplicationPicker : JournlerGradientView {
	
	id delegate;
	NSString *filename;
}

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (NSString*) filename;
- (void) setFilename:(NSString*)aString;

@end

@interface NSObject (MediabarItemApplicationPickerDelegate)

// return yes if the drop is accepted - do something with it!
- (BOOL) mediabarItemApplicationPicker:(MediabarItemApplicationPicker*)appPicker shouldAcceptDrop:(NSString*)aFilename;

@end