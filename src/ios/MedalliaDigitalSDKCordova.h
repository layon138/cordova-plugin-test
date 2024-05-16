#import <Cordova/CDVPlugin.h>
#import <MedalliaDigitalSDK/MedalliaDigitalSDK-Swift.h>

@interface MedalliaDigitalSDKCordova : CDVPlugin <MDFormDelegate, MDFeedbackDelegate, MDInterceptDelegate, MDCustomInterceptDelegate>
- (void)sendMessageSuccess:(NSString*)message command:(CDVInvokedUrlCommand*)command;
- (void)sendMessageFailure:(NSString*)message command:(CDVInvokedUrlCommand*)command;
- (void)sendDelegateCallback:(NSString*)callbackName parameters:(NSDictionary*)parameters command:(CDVInvokedUrlCommand*)command;
- (void)sdkInit:(CDVInvokedUrlCommand*)command;
- (void)setCustomParameter:(CDVInvokedUrlCommand*)command;
- (void)setCustomParameters:(CDVInvokedUrlCommand*)command;
- (void)showForm:(CDVInvokedUrlCommand*)command;
- (void)handleNotification:(CDVInvokedUrlCommand*)command;
- (void)customInterceptTrigger:(CDVInvokedUrlCommand*)command;
- (void)setFormCallback:(CDVInvokedUrlCommand*)command;
- (void)setInvitationCallback:(CDVInvokedUrlCommand*)command;
- (void)setFeedbackCallback:(CDVInvokedUrlCommand*)command;
- (void)setFeedbackCallbackV2:(CDVInvokedUrlCommand*)command;
- (void)setCustomInterceptCallback:(CDVInvokedUrlCommand*)command;
- (void)enableIntercept:(CDVInvokedUrlCommand*)command;
- (void)disableIntercept:(CDVInvokedUrlCommand*)command;
- (void)setLogLevel:(CDVInvokedUrlCommand*)command;
- (void)stopSDK:(CDVInvokedUrlCommand*)command;
- (void)revertStopSDK:(CDVInvokedUrlCommand*)command;
- (void)updateCustomLocale:(CDVInvokedUrlCommand*)command;
- (void)setCustomAppearance:(CDVInvokedUrlCommand*)command;
- (void)setDebugForm:(CDVInvokedUrlCommand*)command;
- (void)closeEngagement:(CDVInvokedUrlCommand*)command;
- (void)setUserId:(CDVInvokedUrlCommand*)command;
- (void)formDidSubmitWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidDismissWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidCloseWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidDisplayWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidThankYouPromptWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidBlockExternalUrlWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)formDidLinkSelectWithFormDelegateData:(MDFormDelegateData *)formDelegateData;
- (void)interceptDidDisplayWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)interceptDidAcceptWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)interceptDidDeclineWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)interceptDidDeferWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)interceptDidCloseWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)interceptDidTriggerSKStoreReviewControllerWithInterceptDelegateData:(MDInterceptDelegateData *)interceptDelegateData;
- (void)feedbackDidSubmitWithFeedbackDelegateData:(MDFeedbackDelegateData *)feedbackDelegateData;
- (void)targetEvaluationDidSuccessWithCustomInterceptDelegateData:(MDCustomInterceptDelegateData *)customInterceptDelegateData;

@end
