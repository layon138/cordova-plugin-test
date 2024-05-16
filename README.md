## MobileSDK-Cordova

![alt text](https://image.ibb.co/bCPDQw/Medallia_color_logo.png)

## Contents

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Communication](#communication)
* [Credits](#credits)
* [License](#license)

## Requirements

## General
* Cordova 1.7.1

# iOS
* iOS 8.0+
* Swift 4.0+

# Android
* minSdkVersion 16
* Cordova android 6.4.0


## Usage

### SDK api

Init sdk:

```javascript
medalliaDigital.init(
  "token",
  function(msg) {},
  function(err) {
    console.log(err);
  }
);
```

Show form:

```javascript
medalliaDigital.showForm(
  "formId",
  function(msg) {},
  function(err) {
    console.log(err);
  }
);
```

```javascript
medalliaDigital.handleNotification(
  "formId",
  function(msg) {},
  function(err) {
    console.log(err);
  }
);
```

Set custom parameter:

```javascript
medalliaDigital.setCustomParameter("key", "value");
```

Set custom parameters:

```javascript
medalliaDigital.setCustomParameters({ key1: "value1", key2: false, key3: 1 });
```

Enable intercept:

```javascript
medalliaDigital.enableIntercept();
```

Disable intercept:

```javascript
medalliaDigital.disableIntercept();
```

Set invitation callbacks:

```javascript
medalliaDigital.setInvitationCallback(function(msg) {
  console.log("setInvitationCallback");
  switch (msg.event) {
    case "onInvitationDisplayed":
      console.log("onInvitationDisplayed: " + msg.data.formId);
      break;
    case "onInvitationAccepted":
      console.log("onInvitationAccepted: " + msg.data.formId);
      break;
    case "onInvitationDeclined":
      console.log("onInvitationDeclined: " + msg.data.formId);
      break;
    case "onInvitationDeclined":
      console.log("onInvitationDeclined: " + msg.data.formId);
      break;
    case "onInvitationDeferred":
      console.log("onInvitationDeferred: " + msg.data.formId);
      break;
  }
});
```

Set form callbacks:

```javascript
medalliaDigital.setFormCallback(function(msg) {
  console.log("show form event: " + msg.event);
  switch (msg.event) {
    case "onFormSubmitted":
      console.log("onFormSubmitted: " + msg.data.formId);
      break;
    case "onFormDismissed":
      console.log("onFormDismissed: " + msg.data.formId);
      break;
    case "onFormClosed":
      console.log("onFormClosed: " + msg.data.formId);
      break;
    case "onFormDisplayed":
      console.log("onFormDisplayed: " + msg.data.formId);
      break;
    case "onFormExternalUrlBlocked":
      console.log("onFormExternalUrlBlocked: " + msg.data.formId);
      break;
  }
});
```

## Communication

* If you **need help**, use [Medallia Digital](http://www.medallia.com/solutions/digital/).
* If you **found a bug**, open an issue.
* If you **have a feature request**, open an issue.

### Resources

* [Documentation](http://www.medallia.com/solutions/digital/)
* [F.A.Q.](http://www.medallia.com/solutions/digital/)

## Credits

* Medallia Digital

## License

MedalliaDigitalSDK is released under the Apache license. See LICENSE for details.