//
//  PDAutoCompleteTextField.h
//  SproutedInterface
//
//  Created by Philip Dow on 7/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDAutoCompleteTextField : NSTextField {
	NSArray		*autoCompleteOptions;
}

- (NSArray*) autoCompleteOptions;
- (void) setAutoCompleteOptions:(NSArray*)options;

@end
