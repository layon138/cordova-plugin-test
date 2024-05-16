var exec = require("cordova/exec");

exports.logLevel = {
  OFF: "OFF",
  FATAL: "FATAL",
  ERROR: "ERROR",
  WARN: "WARN",
  INFO: "INFO",
  DEBUG: "DEBUG",
};

exports.actionType = {
  ACCEPTED: "ACCEPTED",
  DECLINED: "DECLINED",
  DEFERRED: "DEFERRED",
  SKIPPED: "SKIPPED",
};

exports.init = function (token, success, error) {
  exec(success, error, "MedalliaDigitalSDKCordova", "sdkInit", [token]);
};

exports.setCustomParameter = function (name, value) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setCustomParameter", [
    name,
    value,
  ]);
};

exports.setCustomParameters = function (parameters) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setCustomParameters", [
    parameters,
  ]);
};

exports.showForm = function (formId, success, error) {
  exec(success, error, "MedalliaDigitalSDKCordova", "showForm", [formId]);
};

exports.handleNotification = function (formId, success, error) {
  exec(success, error, "MedalliaDigitalSDKCordova", "handleNotification", [
    formId,
  ]);
};

exports.setCustomAppearance = function (appearance) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setCustomAppearance", [appearance]);
};

exports.closeEngagement = function (success, error) {
  exec(success, error, "MedalliaDigitalSDKCordova", "closeEngagement");
};

exports.setDebugForm = function (debug) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setDebugForm", [debug]);
};

exports.setFormCallback = function (callback) {
  exec(callback, null, "MedalliaDigitalSDKCordova", "setFormCallback");
};

exports.setFeedbackCallback = function (callback) {
  exec(callback, null, "MedalliaDigitalSDKCordova", "setFeedbackCallback");
};

exports.setInvitationCallback = function (callback) {
  exec(callback, null, "MedalliaDigitalSDKCordova", "setInvitationCallback");
};

exports.setCustomInterceptCallback = function (callback) {
  exec(callback, null, "MedalliaDigitalSDKCordova", "setCustomInterceptCallback");
};

exports.enableIntercept = function () {
  exec(null, null, "MedalliaDigitalSDKCordova", "enableIntercept");
};

exports.disableIntercept = function () {
  exec(null, null, "MedalliaDigitalSDKCordova", "disableIntercept");
};

exports.setLogLevel = function (logLevel) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setLogLevel", [logLevel]);
};

exports.stopSDK = function (clearData) {
  exec(null, null, "MedalliaDigitalSDKCordova", "stopSDK", [clearData]);
};

exports.revertStopSDK = function () {
  exec(null, null, "MedalliaDigitalSDKCordova", "revertStopSDK");
};

exports.updateCustomLocale = function (locale, success, error) {
  exec(success, error, "MedalliaDigitalSDKCordova", "updateCustomLocale", [
    locale,
  ]);
};

exports.customInterceptTrigger = function (engagementId, actionType, error) {
  exec(null, error, "MedalliaDigitalSDKCordova", "customInterceptTrigger", [
    engagementId,
    actionType,
  ]);
};

exports.setUserId = function (userId) {
  exec(null, null, "MedalliaDigitalSDKCordova", "setUserId", [userId]);
};
