
#import <Cordova/CDVPlugin.h>
#import "MedalliaDigitalSDKCordova.h"

@implementation MedalliaDigitalSDKCordova

CDVInvokedUrlCommand *formDelegateCallbackCommand;
CDVInvokedUrlCommand *interceptDelegateCallbackCommand;
CDVInvokedUrlCommand *feedbackDelegateCallbackCommand;
CDVInvokedUrlCommand *customInterceptDelegateCallbackCommand;

- (void) sendMessageSuccess:(NSString*)message command:(CDVInvokedUrlCommand*)command {
    NSLog(@"Message: %@", message);
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendMessageFailure:(NSString*)message command:(CDVInvokedUrlCommand*)command {
    NSLog(@"Message: %@", message);
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendDelegateCallback:(NSString*)callbackName parameters:(NSDictionary*)parameters
                     command:(CDVInvokedUrlCommand*)command {
    NSLog(@"Parameters: %@", parameters);
    NSDictionary* result = @{@"event":callbackName,@"data":parameters};

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 SDK Init

 - parameter token: String
 - parameter success: () -> ()
 - parameter failure: (MDExternalError) -> ()
 */
- (void)sdkInit:(CDVInvokedUrlCommand*)command {
    NSString* token = [command.arguments objectAtIndex:0];
    if (token == nil) {
        token = @"";
    }

    [MedalliaDigital setSdkFramework:MDSDKFrameworkTypeCordova];
    [MedalliaDigital sdkInitWithToken:token success:^{
        [self sendMessageSuccess:@"Init finished successfuly" command:command];
    } failure:^(MDExternalError * _Nonnull error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];

    }];
}

/**
 Set Custom Parameter

 - parameter name: String
 - parameter value: Any
 */
- (void)setCustomParameter:(CDVInvokedUrlCommand*)command {
    NSString* name = [command.arguments objectAtIndex:0];
    NSString* value = [command.arguments objectAtIndex:1];

    [MedalliaDigital setCustomParameterWithName:name value: value];
}

/**
 Set Custom Parameters

 - parameter parameters: [String : Any]
 */
- (void)setCustomParameters:(CDVInvokedUrlCommand*)command {
    NSDictionary* parameters = [command.arguments objectAtIndex:0];

    [MedalliaDigital setCustomParameters:parameters];
}

/**
 Show Form

 - parameter formId: String
 - parameter success: () -> ()
 - parameter failure: (MDExternalError) -> ()
 */
- (void)showForm:(CDVInvokedUrlCommand*)command{
    NSString* formId = [command.arguments objectAtIndex:0];

    [MedalliaDigital showForm:formId success:^{
        NSString *message = [NSString stringWithFormat:@"Show form: %@", formId];
        [self sendMessageSuccess:message command:command];
    } failure:^(MDExternalError * _Nonnull error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];
    }
     ];


}

/**
 Handle Notification

 - parameter formId: String
 - parameter success: () -> ()
 - parameter failure: (MDExternalError) -> ()
 */
- (void)handleNotification:(CDVInvokedUrlCommand*)command {

    NSString* formId = [command.arguments objectAtIndex:0];
    [MedalliaDigital handleNotification:formId success:^{
        NSString *message = [NSString stringWithFormat:@"Show form: %@", formId];
        [self sendMessageSuccess:message command:command];
    } failure:^(MDExternalError * error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];
    }];
}

/**
 Set Form Delegate

 - parameter formDelegate: MDFormDelegate
 */
- (void)setFormCallback:(CDVInvokedUrlCommand*)command {
    formDelegateCallbackCommand = command;
    [MedalliaDigital setFormDelegate:self];
}

/**
 Set Invitation Delegate

 - parameter invitationDelegate: MDInvitationDelegate
 */
- (void)setInvitationCallback:(CDVInvokedUrlCommand*)command {
    interceptDelegateCallbackCommand = command;
    [MedalliaDigital setInterceptDelegate:self];
}

/**
 Set Feedback Delegate

 - parameter feedbackDelegate: MDFeedbackDelegate
 */
- (void)setFeedbackCallback:(CDVInvokedUrlCommand*)command {
    feedbackDelegateCallbackCommand = command;
    [MedalliaDigital setFeedbackDelegate:self];
}

/**
 Set Custom Intercept Delegate
 - parameter customInterceptDelegate: MDCustomInterceptDelegate
 */
-(void)setCustomInterceptCallback:(CDVInvokedUrlCommand *)command {
    customInterceptDelegateCallbackCommand = command;
    [MedalliaDigital setCustomInterceptDelegate:self];
}

/**
 Enable Intercept
 */
- (void)enableIntercept:(CDVInvokedUrlCommand*)command {
    [MedalliaDigital enableIntercept];
}

/**
 Disable Intercept
 */
- (void)disableIntercept:(CDVInvokedUrlCommand*)command {
    [MedalliaDigital disableIntercept];
}

- (void)setLogLevel:(CDVInvokedUrlCommand*)command {
    NSString* logLevelString = [command.arguments objectAtIndex:0];
    MDLogLevel logLevel = MDLogLevelOff;
    if ([logLevelString isEqualToString:@"FATAL"]) {
        logLevel = MDLogLevelFatal;
    } else if ([logLevelString isEqualToString:@"ERROR"]) {
        logLevel = MDLogLevelError;
    } else if ([logLevelString isEqualToString:@"WARN"]) {
        logLevel = MDLogLevelWarn;
    } else if ([logLevelString isEqualToString:@"INFO"]) {
        logLevel = MDLogLevelInfo;
    } else if ([logLevelString isEqualToString:@"DEBUG"]) {
        logLevel = MDLogLevelDebug;
    }
    [MedalliaDigital setLogLevel: logLevel];
}

- (void)stopSDK:(CDVInvokedUrlCommand*)command{
    BOOL clearData = [command.arguments objectAtIndex:0];
    [MedalliaDigital stopSDKWithClearData:clearData];
}

- (void)revertStopSDK:(CDVInvokedUrlCommand*)command {
    [MedalliaDigital revertStopSDK];
}

/**
 Update custom locale

 - parameter locale: String
 - parameter success: () -> ()
 - parameter failure: (MDExternalError) -> ()
 */
- (void)updateCustomLocale:(CDVInvokedUrlCommand*)command {

    NSString* locale = [command.arguments objectAtIndex:0];
    [MedalliaDigital updateCustomLocale: locale success:^(NSString * message) {
        NSString *msg = [NSString stringWithFormat:@"Update custom locale: %@", message];
        [self sendMessageSuccess:msg command:command];
    } failure:^(MDExternalError * error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];
    }];
}

/**
 Custom Intercept Trigger
 - parameter engagementId: String
 - parameter actionType: MDInterceptActionType
 - parameter failure: (MDExternalError) -> ()
 */
- (void)customInterceptTrigger:(CDVInvokedUrlCommand*)command {
    NSString* engagementId = [command.arguments objectAtIndex:0];
    NSString* actionTypeString = [command.arguments objectAtIndex:1];
    MDInterceptActionType actionType = MDInterceptActionTypeDeclined;

    if ([actionTypeString isEqualToString:@"ACCEPTED"]) {
        actionType = MDInterceptActionTypeAccepted;
    } else if ([actionTypeString isEqualToString:@"DEFERRED"]) {
        actionType = MDInterceptActionTypeDeferred;
    } else if ([actionTypeString isEqualToString:@"SKIPPED"]) {
        actionType = MDInterceptActionTypeSkipped;
    }

    [MedalliaDigital customInterceptTriggerWithEngagementId:engagementId actionType:actionType failure:^(MDExternalError * _Nonnull error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];
    }];
}

- (void)setCustomAppearance:(CDVInvokedUrlCommand*)command {
    NSString* appearanceMode = [command.arguments objectAtIndex:0];
    MDAppearanceMode appearanceModeType = MDAppearanceModeUnknown;
    if ([appearanceMode.uppercaseString isEqualToString:@"DARK"]) {
        appearanceModeType = MDAppearanceModeDark;
    } else if ([appearanceMode.uppercaseString isEqualToString:@"LIGHT"]) {
        appearanceModeType = MDAppearanceModeLight;
    }
    [MedalliaDigital setCustomAppearance: appearanceModeType];
}

- (void)setDebugForm:(CDVInvokedUrlCommand*)command {
    NSString* debugString = [command.arguments objectAtIndex:0];
    BOOL debug = [debugString isEqualToString:@"YES"];
    [MedalliaDigital setDebugForm: debug];
}

/**
 Close Engagement
 
 - parameter success: () -> ()
 - parameter failure: (MDExternalError) -> ()
 */
- (void)closeEngagement:(CDVInvokedUrlCommand*)command{
    [MedalliaDigital closeEngagementWithSuccess:^{
        [self sendMessageSuccess:@"Close Engagement" command:command];
    } failure:^(MDExternalError * _Nonnull error) {
        NSString *errorMsg = [NSString stringWithFormat:@"Close Engagement Error message: %@, statusCode: %ld", error.message , (long)error.statusCode];
        [self sendMessageFailure:errorMsg command:command];
    }];
}

- (void)setUserId:(CDVInvokedUrlCommand*)command {
    NSString* userIdString = [command.arguments objectAtIndex:0];
    [MedalliaDigital setUserId: userIdString];
}

//-------------------------------------------------------------------------------------------
// MARK: - MDFormDelegate
//-------------------------------------------------------------------------------------------

- (void)formDidSubmitWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle 'submit' button click from a form
    if (formDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
        NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
        NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                      @"formId": [formDelegateData engagementId],
                                      @"formTriggerType": triggerType};
        [self sendDelegateCallback:@"onFormSubmitted" parameters:parameters command:formDelegateCallbackCommand];
    }
}

- (void)formDidDismissWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle dismissing a form
    if (formDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
        NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
        NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                      @"formId": [formDelegateData engagementId],
                                      @"formTriggerType": triggerType};
        [self sendDelegateCallback:@"onFormDismissed" parameters:parameters command:formDelegateCallbackCommand];
    }
}

- (void)formDidCloseWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle closing a form
    if (formDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
        NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
        NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                      @"formId": [formDelegateData engagementId],
                                      @"formTriggerType": triggerType};
        [self sendDelegateCallback:@"onFormClosed" parameters:parameters command:formDelegateCallbackCommand];
    }
}

- (void)formDidDisplayWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle displaying a form
     if (formDelegateCallbackCommand != nil) {
         NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
         NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
         NSString *appearanceSet = [formDelegateData formHeaderAppearanceSet] == MDAppearanceModeDark ? @"dark" : [formDelegateData formHeaderAppearanceSet] == MDAppearanceModeLight ? @"light" :  @"unknown";
         NSString *appearanceDisplay = [formDelegateData formHeaderAppearanceDisplay] == MDAppearanceModeDark ? @"dark" : [formDelegateData formHeaderAppearanceDisplay] == MDAppearanceModeLight ? @"light" :  @"unknown";

        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"formId":[formDelegateData engagementId],
                                      @"formTriggerType":triggerType,
                                      @"formLocaleSet" : [formDelegateData formLocaleSet] != nil ? [formDelegateData formLocaleSet] : @"",
                                      @"formLocaleDisplay" : [formDelegateData formLocaleDisplay] != nil ? [formDelegateData formLocaleDisplay] : @"",
                                      @"appearanceSet" : appearanceSet,
                                      @"appearanceDisplay" : appearanceDisplay};
        [self sendDelegateCallback:@"onFormDisplayed" parameters:parameters command:formDelegateCallbackCommand];
     }
}

-(void)formDidThankYouPromptWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle internal url in a form being blocked
        if (formDelegateCallbackCommand != nil) {
            NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
            NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
            NSString *appearanceSet = [formDelegateData formHeaderAppearanceSet] == MDAppearanceModeDark ? @"dark" : [formDelegateData formHeaderAppearanceSet] == MDAppearanceModeLight ? @"light" :  @"unknown";
            NSString *appearanceDisplay = [formDelegateData formHeaderAppearanceDisplay] == MDAppearanceModeDark ? @"dark" : [formDelegateData formHeaderAppearanceDisplay] == MDAppearanceModeLight ? @"light" :  @"unknown";

            NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                          @"formId": [formDelegateData engagementId],
                                          @"formTriggerType": triggerType,
                                          @"appearanceSet" : appearanceSet,
                                          @"appearanceDisplay" : appearanceDisplay};
            [self sendDelegateCallback:@"onFormThankYouPrompt" parameters:parameters command:formDelegateCallbackCommand];
        }
}

- (void)formDidBlockExternalUrlWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle internal url in a form being blocked
    if (formDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
        NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
        NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                      @"formId": [formDelegateData engagementId],
                                      @"formTriggerType": triggerType,
                                      @"blockedUrl": [formDelegateData url]};
        [self sendDelegateCallback:@"onFormExternalUrlBlocked" parameters:parameters command:formDelegateCallbackCommand];
    }
}

- (void)formDidLinkSelectWithFormDelegateData:(MDFormDelegateData *)formDelegateData {
    //Handle internal url in a form being blocked
    if (formDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[formDelegateData timestamp]];
        NSString *triggerType = [formDelegateData formTriggerType] == MDFormTriggerTypeCode ? @"form" : @"invite" ;
        NSDictionary *parameters =  @{@"timeStamp": timeStamp,
                                      @"formId": [formDelegateData engagementId],
                                      @"formTriggerType": triggerType,
                                      @"url": [formDelegateData url],
                                      @"isBlocked":@([formDelegateData isBlocked])};
        [self sendDelegateCallback:@"onFormLinkSelected" parameters:parameters command:formDelegateCallbackCommand];
    }
}


//-------------------------------------------------------------------------------------------
// MARK: - MDInterceptDelegate
//-------------------------------------------------------------------------------------------

- (void)interceptDidDisplayWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    //Handle invitation to a form being displayed
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSString *type = [interceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating";
        NSString *appearanceSet = [interceptDelegateData appearanceSet] == MDAppearanceModeDark ? @"dark" : [interceptDelegateData appearanceSet] == MDAppearanceModeLight ? @"light" :  @"unknown";
        NSString *appearanceDisplay = [interceptDelegateData appearanceDisplay] == MDAppearanceModeDark ? @"dark" : [interceptDelegateData appearanceDisplay] == MDAppearanceModeLight ? @"light" :  @"unknown";

        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId],
                                      @"engagementType":type,
                                      @"appearanceSet" : appearanceSet,
                                      @"appearanceDisplay" : appearanceDisplay};
        [self sendDelegateCallback:@"onInvitationDisplayed" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

- (void)interceptDidAcceptWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    //Handle invitation to a form being displayed
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSString *type = [interceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating";
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId],
                                      @"engagementType":type};
        [self sendDelegateCallback:@"onInvitationAccepted" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

- (void)interceptDidDeclineWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    //Handle invitation to a form being displayed
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSString *type = [interceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating";
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId],
                                      @"engagementType":type};
        [self sendDelegateCallback:@"onInvitationDeclined" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

- (void)interceptDidDeferWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    //Handle invitation to a form being displayed
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSString *type = [interceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating";
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId],
                                      @"engagementType":type};
        [self sendDelegateCallback:@"onInvitationDeferred" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

- (void)interceptDidCloseWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSString *type = [interceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating";
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId],
                                      @"engagementType":type};
        [self sendDelegateCallback:@"onInvitationClosed" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

- (void)interceptDidTriggerSKStoreReviewControllerWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData {
    if (interceptDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble:[interceptDelegateData timestamp]];
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[interceptDelegateData engagementId]};
        [self sendDelegateCallback:@"onInvitationTriggerInAppReview" parameters:parameters command:interceptDelegateCallbackCommand];
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - MDFeedbackDelegate
//-------------------------------------------------------------------------------------------
-(void)feedbackDidSubmitWithFeedbackDelegateData:(MDFeedbackDelegateData *)feedbackDelegateData {
    //Handle Submitted feedback payload
    if (feedbackDelegateCallbackCommand != nil) {
        NSNumber *timeStamp = [NSNumber numberWithDouble: [feedbackDelegateData timestamp]];
        NSDictionary *parameters =  @{@"timeStamp":timeStamp,
                                      @"engagementId":[feedbackDelegateData engagementId],
                                      @"feedbackClientCorrelationId":[feedbackDelegateData feedbackClientCorrelationId],
                                      @"payload":[feedbackDelegateData payload]};
        [self sendDelegateCallback:@"onFeedbackSubmitted" parameters:parameters command:feedbackDelegateCallbackCommand];
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - MDCustomInterceptDelegate
//-------------------------------------------------------------------------------------------

-(void)targetEvaluationDidSuccessWithCustomInterceptDelegateData:(MDCustomInterceptDelegateData *)customInterceptDelegateData {
    if (customInterceptDelegateCallbackCommand != nil) {
        NSNumber *formPreloadTimeStamp = [NSNumber numberWithDouble: [customInterceptDelegateData formPreloadTimestamp]];
        NSNumber *targetingEvaluationTimeStamp = [NSNumber numberWithDouble: [customInterceptDelegateData targetingEvaluationTimestamp]];
        NSString *type = [customInterceptDelegateData engagementType] == MDEngagementTypeForm ? @"form" : @"appRating" ;
        MDCustomInterceptPayload *payload = [customInterceptDelegateData payload];
        NSDictionary *payLoad = @{@"titleText": [payload titleText],
                                  @"subtitleText": [payload subtitleText],
                                  @"provideFeedbackText": [payload provideFeedbackText],
                                  @"deferText": [payload deferText],
                                  @"declineText": [payload declineText],
        };
        
        NSDictionary *parameters =  @{@"name" : @"onTargetEvaluationSuccess",
                                      @"formPreloadTimestamp": formPreloadTimeStamp,
                                      @"targetingEvaluationTimestamp": targetingEvaluationTimeStamp,
                                      @"engagementId": [customInterceptDelegateData engagementId],
                                      @"engagementType": type,
                                      @"payload": payLoad
        };
        [self sendDelegateCallback:@"onTargetEvaluationSuccess" parameters:parameters command:customInterceptDelegateCallbackCommand];
    }
}

@end

