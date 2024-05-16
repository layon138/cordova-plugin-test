package com.medallia.plugin;

import android.text.TextUtils;
import com.medallia.digital.mobilesdk.MDCustomInterceptListenerData;
import com.medallia.digital.mobilesdk.MDExternalError;
import com.medallia.digital.mobilesdk.MDFeedbackListener;
import com.medallia.digital.mobilesdk.MDFeedbackListenerData;
import com.medallia.digital.mobilesdk.MDFormListener;
import com.medallia.digital.mobilesdk.MDFormListenerData;
import com.medallia.digital.mobilesdk.MDInterceptListener;
import com.medallia.digital.mobilesdk.MDInterceptListenerData;
import com.medallia.digital.mobilesdk.MDLogLevel;
import com.medallia.digital.mobilesdk.MDResultCallback;
import com.medallia.digital.mobilesdk.MDCallback;
import com.medallia.digital.mobilesdk.MDSdkFrameworkType;
import com.medallia.digital.mobilesdk.MedalliaDigital;
import com.medallia.digital.mobilesdk.MDCustomInterceptListener;
import com.medallia.digital.mobilesdk.MDFailureCallback;
import com.medallia.digital.mobilesdk.MDInterceptActionType;
import com.medallia.digital.mobilesdk.MDAppearanceMode;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class MedalliaDigitalSDKCordova extends CordovaPlugin {

    // region enums
    enum ACTION {
        INIT, SHOW_FORM, HANDLE_NOTIFICATION, SET_FORM_LISTENER, SET_FEEDBACK_LISTENER, SET_FEEDBACK_LISTENERV2,
        SET_CUSTOM_PARAMETER, SET_CUSTOM_PARAMETERS, SET_INVITATION_LISTENER, ENABLE_INTERCEPT, DISABLE_INTERCEPT,
        SET_LOG_LEVEL, STOP_SDK, REVERT_STOP_SDK, UPDATE_CUSTOM_LOCALE, SET_CUSTOM_INTERCEPT_LISTENER, CUSTOM_INTERCEPT_TRIGGER, CUSTOM_APPEARANCE,
        CLOSE_ENGAGEMENT, SET_USER_ID;

        @Override
        public String toString() {
            switch (this) {
                case INIT:
                    return "sdkInit";
                case SHOW_FORM:
                    return "showForm";
                case HANDLE_NOTIFICATION:
                    return "handleNotification";
                case SET_FEEDBACK_LISTENER:
                    return "setFeedbackCallback";
                case SET_FORM_LISTENER:
                    return "setFormCallback";
                case SET_CUSTOM_PARAMETER:
                    return "setCustomParameter";
                case SET_CUSTOM_PARAMETERS:
                    return "setCustomParameters";
                case SET_INVITATION_LISTENER:
                    return "setInvitationCallback";
                case SET_CUSTOM_INTERCEPT_LISTENER:
                    return "setCustomInterceptCallback";
                case CUSTOM_INTERCEPT_TRIGGER:
                    return "customInterceptTrigger";
                case ENABLE_INTERCEPT:
                    return "enableIntercept";
                case CUSTOM_APPEARANCE:
                    return "setCustomAppearance";
                case DISABLE_INTERCEPT:
                    return "disableIntercept";
                case SET_LOG_LEVEL:
                    return "setLogLevel";
                case STOP_SDK:
                    return "stopSDK";
                case REVERT_STOP_SDK:
                    return "revertStopSDK";
                case UPDATE_CUSTOM_LOCALE:
                    return "updateCustomLocale";
                case CLOSE_ENGAGEMENT:
                    return "closeEngagement";
                case SET_USER_ID:
                    return "setUserId";
            }

            return super.toString();
        }
    }
    // endreigon

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION.INIT.toString())) {
            initSdk(args.getString(0), callbackContext);
            return true;

        } else if (action.equals(ACTION.SHOW_FORM.toString())) {
            showForm(args.getString(0), callbackContext);
            return true;
        } else if (action.equals(ACTION.HANDLE_NOTIFICATION.toString())) {
            handleNotification(args.getString(0), callbackContext);
            return true;
        } else if (action.equals(ACTION.SET_FORM_LISTENER.toString())) {
            setFormListener(callbackContext);
            return true;
        } else if (action.equals(ACTION.SET_FEEDBACK_LISTENER.toString())) {
            setFeedbackListener(callbackContext);
            return true;
        } else if (action.equals(ACTION.SET_CUSTOM_PARAMETER.toString())) {
            String key = args.getString(0);
            Object value = args.get(1);

            setCustomParamer(key, value);
            return true;
        } else if (action.equals(ACTION.SET_CUSTOM_PARAMETERS.toString())) {
            JSONObject customParameters = new JSONObject(args.getString(0));
            setCustomParamers(customParameters);
            return true;
        } else if (action.equals(ACTION.SET_INVITATION_LISTENER.toString())) {
            setInvitationListener(callbackContext);
            return true;
        } else if (action.equals(ACTION.SET_CUSTOM_INTERCEPT_LISTENER.toString())) {
            setCustomInterceptListener(callbackContext);
            return true;
        } else if (action.equals(ACTION.CUSTOM_INTERCEPT_TRIGGER.toString())) {
            customInterceptTrigger(args.getString(0), args.getString(1), callbackContext);
            return true; 
        } else if (action.equals(ACTION.ENABLE_INTERCEPT.toString())) {
            enableIntercept(true);
            return true;
        } else if (action.equals(ACTION.CUSTOM_APPEARANCE.toString())) {
            setCustomAppearance(args.getString(0));
            return true;
        } else if (action.equals(ACTION.DISABLE_INTERCEPT.toString())) {
            enableIntercept(false);
            return true;
        } else if (action.equals(ACTION.SET_LOG_LEVEL.toString())) {
            setLogLevel(args.getString(0));
            return true;
        } else if (action.equals(ACTION.STOP_SDK.toString())) {
            stopSDK(args.getBoolean(0));
            return true;
        } else if (action.equals(ACTION.REVERT_STOP_SDK.toString())) {
            revertStopSDK();
            return true;
        } else if (action.equals(ACTION.UPDATE_CUSTOM_LOCALE.toString())) {
            updateCustomLocale(args.getString(0), callbackContext);
            return true;
        } else if (action.equals(ACTION.CLOSE_ENGAGEMENT.toString())) {
            closeEngagement(callbackContext);
            return true;
        } else if (action.equals(ACTION.SET_USER_ID.toString())) {
            setUserId(args.getString(0));
            return true;
        }

        return false;
    }

    private void initSdk(final String token, final CallbackContext callbackContext) {
        MedalliaDigital.setActivity(cordova.getActivity());
        MedalliaDigital.setSdkFramework(MDSdkFrameworkType.CORDOVA);

        MedalliaDigital.init(cordova.getActivity().getApplication(), token, new MDResultCallback() {
            @Override
            public void onSuccess() {
                callbackContext.success("");
            }

            @Override
            public void onError(MDExternalError error) {
                callbackContext.error(error.getMessage());
            }
        });
    }

    private void showForm(final String formId, final CallbackContext callbackContext) {
        MedalliaDigital.showForm(formId, new MDResultCallback() {
            @Override
            public void onSuccess() {
                callbackContext.success("");
            }

            @Override
            public void onError(MDExternalError error) {
                callbackContext.error(error.getMessage());
            }
        });
    }

    private void handleNotification(final String formId, final CallbackContext callbackContext) {
        MedalliaDigital.handleNotification(formId, new MDResultCallback() {
            @Override
            public void onSuccess() {
                callbackContext.success("");
            }

            @Override
            public void onError(MDExternalError error) {
                callbackContext.error(error.getMessage());
            }
        });
    }

    private void setCustomParamer(final String key, final Object value) {
        MedalliaDigital.setCustomParameter(key, value);
    }

    private void setCustomParamers(final JSONObject customParameters) {
        try {
            MedalliaDigital.setCustomParameters(toHashMap(customParameters));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void setFeedbackListener(final CallbackContext callback) {
        MedalliaDigital.setFeedbackListener(new MDFeedbackListener() {
            @Override
            public void onFeedbackSubmitted(MDFeedbackListenerData mdFeedbackListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFeedbackSubmitted");
                    data.put("engagementId", mdFeedbackListenerData.getEngagementId());
                    data.put("feedbackClientCorrelationId", mdFeedbackListenerData.getFeedbackClientCorrelationId());
                    data.put("timestamp", mdFeedbackListenerData.getTimestamp());
                    data.put("payload", mdFeedbackListenerData.getFeedbackPayload());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }
        });
    }

    private void setFormListener(final CallbackContext callback) {
        MedalliaDigital.setFormListener(new MDFormListener() {
            @Override
            public void onFormSubmitted(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormSubmitted");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onFormDismissed(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormDismissed");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onFormClosed(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormClosed");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onFormDisplayed(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormDisplayed");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    data.put("formLocaleSet", mdFormListenerData.getFormLocaleSet());
                    data.put("formLocaleDisplay", mdFormListenerData.getFormLocaleDisplay());
                    data.put("formHeaderAppearanceSet", mdFormListenerData.getFormHeaderAppearanceSet().toString());
                    data.put("formHeaderAppearanceDisplay", mdFormListenerData.getFormHeaderAppearanceDisplay().toString());

                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onFormThankYouPrompt(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormThankYouPrompt");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    data.put("formHeaderAppearanceSet", mdFormListenerData.getFormHeaderAppearanceSet().toString());
                    data.put("formHeaderAppearanceDisplay", mdFormListenerData.getFormHeaderAppearanceDisplay().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onFormLinkSelected(MDFormListenerData mdFormListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onFormLinkSelected");
                    data.put("timestamp", mdFormListenerData.getTimestamp());
                    data.put("engagementId", mdFormListenerData.getEngagementId());
                    data.put("formTriggerType", mdFormListenerData.getFormTriggerType().toString());
                    data.put("url", mdFormListenerData.getUrl());
                    data.put("isBlocked", mdFormListenerData.isBlocked());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }
        });
    }

    private void setInvitationListener(final CallbackContext callback) {
        MedalliaDigital.setInterceptListener(new MDInterceptListener() {
            @Override
            public void onInterceptDisplayed(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationDisplayed");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    data.put("engagementType", mdInterceptListenerData.getEngagementType().toString());
                    data.put("formHeaderAppearanceSet", mdInterceptListenerData.getInterceptAppearanceSet().toString());
                    data.put("formHeaderAppearanceDisplay", mdInterceptListenerData.getInterceptAppearanceDisplay().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onInterceptAccepted(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationAccepted");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    data.put("engagementType", mdInterceptListenerData.getEngagementType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onInterceptDeclined(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationDeclined");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    data.put("engagementType", mdInterceptListenerData.getEngagementType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onInterceptDeferred(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationDeferred");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    data.put("engagementType", mdInterceptListenerData.getEngagementType().toString());
                    data.put("reason", mdInterceptListenerData.getReason().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onInterceptClosed(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationClosed");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    data.put("engagementType", mdInterceptListenerData.getEngagementType().toString());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }

            @Override
            public void onInterceptTriggerInAppReview(MDInterceptListenerData mdInterceptListenerData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    jsonObject.put("event", "onInvitationTriggerInAppReview");
                    data.put("timestamp",mdInterceptListenerData.getTimestamp());
                    data.put("engagementId", mdInterceptListenerData.getEngagementId());
                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);
            }
        });
    }

    private void setCustomInterceptListener(final CallbackContext callback) {
        MedalliaDigital.setCustomInterceptListener(new MDCustomInterceptListener() {
            @Override
            public void onTargetEvaluationSuccess(MDCustomInterceptListenerData mdCustomInterceptData) {
                JSONObject jsonObject = new JSONObject();
                try {
                    JSONObject data = new JSONObject();
                    JSONObject payloadJson = new JSONObject();
                    jsonObject.put("event", "onTargetEvaluationSuccess");
                    data.put("formPreloadTimestamp", String.valueOf(mdCustomInterceptData.getFormPreloadTimestamp()));
                    data.put("targetingEvaluationTimestamp", String.valueOf(mdCustomInterceptData.getTargetingEvaluationTimestamp()));
                    data.put("engagementId", mdCustomInterceptData.getEngagementId());
                    data.put("engagementType", mdCustomInterceptData.getEngagementType().toString());
                    payloadJson.put("titleText", mdCustomInterceptData.getCustomInterceptPayload().getTitleText());
                    payloadJson.put("subtitleText", mdCustomInterceptData.getCustomInterceptPayload().getSubtitleText());
                    payloadJson.put("provideFeedbackText", mdCustomInterceptData.getCustomInterceptPayload().getProvideFeedbackText());
                    payloadJson.put("declineText", mdCustomInterceptData.getCustomInterceptPayload().getDeclineText());
                    payloadJson.put("deferText", mdCustomInterceptData.getCustomInterceptPayload().getDeferText());

                    data.put("payload", payloadJson);

                    jsonObject.put("data", data);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                PluginResult result = new PluginResult(PluginResult.Status.OK, jsonObject);
                result.setKeepCallback(true);

                callback.sendPluginResult(result);

            }
        });
    }

    private void customInterceptTrigger(String engagementId, String actionType, final CallbackContext callbackContext) {
        MDInterceptActionType action = MDInterceptActionType.declined;
        switch (actionType.toUpperCase()) {
            case "ACCEPTED": {
                action = MDInterceptActionType.accepted;
                break;
            }
            case "DEFERRED": {
                action = MDInterceptActionType.deferred;
                break;
            }
            case "SKIPPED": {
                action = MDInterceptActionType.skipped;
                break;
            }
        }
        MedalliaDigital.customInterceptTrigger(engagementId, action,
                new MDFailureCallback() {
                    @Override
                    public void onError(MDExternalError error) {
                        callbackContext.error(error.getMessage());
                    }
                });
    }

    private void enableIntercept(final boolean enable) {
        if (enable) {
            MedalliaDigital.enableIntercept();
        } else {
            MedalliaDigital.disableIntercept();
        }
    }

    private void setCustomAppearance(String appearance) {
        MDAppearanceMode mdAppearanceMode = MDAppearanceMode.unknown;
        switch (appearance.toUpperCase()) {
            case "LIGHT": {
                mdAppearanceMode = MDAppearanceMode.light;
                break;
            }
            case "DARK": {
                mdAppearanceMode = MDAppearanceMode.dark;
                break;
            }
        }
        MedalliaDigital.setCustomAppearance(mdAppearanceMode);
    }

    private void setLogLevel(String logLevel) {
        if (TextUtils.isEmpty(logLevel)) {
            MedalliaDigital.setLogLevel(MDLogLevel.OFF);
        }

        MDLogLevel mdLogLevel = MDLogLevel.OFF;

        for (MDLogLevel level : MDLogLevel.values()) {
            if (level.toString().equals(logLevel)) {
                mdLogLevel = level;
                break;
            }
        }

        MedalliaDigital.setLogLevel(mdLogLevel);
    }

    private void stopSDK(Boolean clearData) {
        if (clearData != null) {
            MedalliaDigital.stopSDK(clearData);
            return;
        }

        MedalliaDigital.stopSDK(false);
    }

    private void revertStopSDK() {
        MedalliaDigital.revertStopSDK();
    }

    private void updateCustomLocale(final String locale, final CallbackContext callbackContext) {
        MedalliaDigital.updateCustomLocale(locale, new MDCallback() {
            @Override
            public void onSuccess(String message) {
                callbackContext.success(message);
            }

            @Override
            public void onError(MDExternalError error) {
                callbackContext.error(error.getMessage());
            }
        });
    }

    private void closeEngagement(final CallbackContext callbackContext) {
        MedalliaDigital.closeEngagement(new MDResultCallback() {
            @Override
            public void onSuccess() {
                callbackContext.success("Close Engagement Sucess");
            }

            @Override
            public void onError(MDExternalError error) {
                callbackContext.error(error.getMessage());
            }
        });
    }

    private void setUserId(String userId) {
        MedalliaDigital.setUserId(userId);
    }

    private HashMap<String, Object> toHashMap(JSONObject object) throws JSONException {
        HashMap<String, Object> map = new HashMap<String, Object>();

        Iterator<String> keysItr = object.keys();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toHashMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }

    private List<Object> toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for (int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if (value instanceof JSONArray) {
                value = toList((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = toHashMap((JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }
}