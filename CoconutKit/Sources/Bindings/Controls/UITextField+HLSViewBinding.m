//
//  UITextField+HLSViewBinding.m
//  CoconutKit
//
//  Created by Samuel Défago on 07/03/14.
//  Copyright (c) 2014 Samuel Défago. All rights reserved.
//

#import "UITextField+HLSViewBinding.h"

#import "HLSRuntime.h"

// Original implementation of the methods we swizzle
static id (*s_UITextField__initWithFrame_Imp)(id, SEL, CGRect) = NULL;
static id (*s_UITextField__initWithCoder_Imp)(id, SEL, id) = NULL;
static void (*s_UITextField__dealloc_Imp)(__unsafe_unretained id, SEL) = NULL;
static void (*s_UITextField__setText_Imp)(id, SEL, id) = NULL;

// Swizzled method implementations
static id swizzled_UITextField__initWithFrame_Imp(UITextField *self, SEL _cmd, CGRect frame);
static id swizzled_UITextField__initWithCoder_Imp(UITextField *self, SEL _cmd, NSCoder *aDecoder);
static void swizzled_UITextField__dealloc_Imp(__unsafe_unretained UITextField *self, SEL _cmd);
static void swizzled_UITextField__setText_Imp(UITextField *self, SEL _cmd, NSString *text);

@implementation UITextField (HLSViewBindingImplementation)

#pragma mark Class methods

+ (void)load
{
    s_UITextField__initWithFrame_Imp = (id (*)(id, SEL, CGRect))hls_class_swizzleSelector(self,
                                                                                          @selector(initWithFrame:),
                                                                                          (IMP)swizzled_UITextField__initWithFrame_Imp);
    s_UITextField__initWithCoder_Imp = (id (*)(id, SEL, id))hls_class_swizzleSelector(self,
                                                                                      @selector(initWithCoder:),
                                                                                      (IMP)swizzled_UITextField__initWithCoder_Imp);
    s_UITextField__dealloc_Imp = (void (*)(id, SEL))hls_class_swizzleSelector(self,
                                                                              NSSelectorFromString(@"dealloc"),
                                                                              (IMP)swizzled_UITextField__dealloc_Imp);
    s_UITextField__setText_Imp = (void (*)(id, SEL, id))hls_class_swizzleSelector(self,
                                                                                  @selector(setText:),
                                                                                  (IMP)swizzled_UITextField__setText_Imp);
}

#pragma mark HLSViewBindingImplementation protocol implementation

+ (BOOL)canDisplayPlaceholder
{
    return YES;
}

- (void)updateViewWithValue:(id)value animated:(BOOL)animated
{
    self.text = value;
}

- (id)inputValueWithClass:(Class)inputClass
{
    return self.text;
}

#pragma mark Notification callbacks

- (void)textFieldDidChange:(NSNotification *)notification
{
    [self check:YES update:YES withInputValue:self.text error:NULL];
}

@end

#pragma mark Static functions

static void commonInit(UITextField *self)
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

static id swizzled_UITextField__initWithFrame_Imp(UITextField *self, SEL _cmd, CGRect frame)
{
    if ((self = (*s_UITextField__initWithFrame_Imp)(self, _cmd, frame))) {
        commonInit(self);
    }
    return self;
}

static id swizzled_UITextField__initWithCoder_Imp(UITextField *self, SEL _cmd, NSCoder *aDecoder)
{
    if ((self = (*s_UITextField__initWithCoder_Imp)(self, _cmd, aDecoder))) {
        commonInit(self);
    }
    return self;
}

// Marked as __unsafe_unretained to avoid ARC inserting incorrect memory management calls leading to crashes for -dealloc
static void swizzled_UITextField__dealloc_Imp(__unsafe_unretained UITextField *self, SEL _cmd)
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self];
    
    (*s_UITextField__dealloc_Imp)(self, _cmd);
}

static void swizzled_UITextField__setText_Imp(UITextField *self, SEL _cmd, NSString *text)
{
    (*s_UITextField__setText_Imp)(self, _cmd, text);
    
    [self check:YES update:YES withInputValue:text error:NULL];
}
