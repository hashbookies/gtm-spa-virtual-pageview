___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_dd_spa_virtual_pageview",
  "version": 1,
  "displayName": "SPA Virtual Pageview",
  "categories": [
    "ANALYTICS",
    "TAG_MANAGEMENT",
    "UTILITY"
  ],
  "description": "Pushes clean virtual pageview events to the dataLayer for single-page applications and headless frontends.",
  "containerContexts": [
    "WEB"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event Name",
    "simpleValueType": true,
    "defaultValue": "page_view",
    "help": "Event name to push to the dataLayer.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "dataLayerName",
    "displayName": "Data Layer Name",
    "simpleValueType": true,
    "defaultValue": "dataLayer",
    "help": "Use dataLayer unless your container is configured with a custom data layer name.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "includeReferrer",
    "checkboxText": "Include Page Referrer",
    "simpleValueType": true,
    "help": "Enable this to add page_referrer to the pushed event."
  },
  {
    "type": "TEXT",
    "name": "pageReferrer",
    "displayName": "Page Referrer Value",
    "simpleValueType": true,
    "help": "Optional referrer value, such as a History Old URL variable.",
    "enablingConditions": [
      {
        "paramName": "includeReferrer",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "preventDuplicateLocation",
    "checkboxText": "Prevent Duplicate Page Location",
    "simpleValueType": true,
    "help": "Skip the push when this exact page_location was already pushed by this template during the current page lifetime."
  },
  {
    "type": "CHECKBOX",
    "name": "deferRead",
    "checkboxText": "Defer Read Until Route Update",
    "simpleValueType": true,
    "help": "Uses callLater to read URL and title after the current History Change event completes."
  },
  {
    "type": "CHECKBOX",
    "name": "debugMode",
    "checkboxText": "Enable Debug Logging",
    "simpleValueType": true,
    "help": "Logs skipped duplicates and pushed payloads in GTM preview/debug environments."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const createQueue = require('createQueue');
const getUrl = require('getUrl');
const readTitle = require('readTitle');
const templateStorage = require('templateStorage');
const callLater = require('callLater');
const logToConsole = require('logToConsole');
const getType = require('getType');
const makeString = require('makeString');

const STORAGE_KEY = 'gtm_spa_virtual_pageview_last_location';

const normalize = function(value) {
  if (getType(value) !== 'string') return '';
  return makeString(value).trim();
};

const log = function(message, value) {
  if (data.debugMode === true) {
    logToConsole('[SPA Virtual Pageview] ' + message, value || '');
  }
};

const buildPagePath = function() {
  const path = normalize(getUrl('path')) || '/';
  const query = normalize(getUrl('query'));
  return query ? path + '?' + query : path;
};

const pushPageview = function() {
  const dataLayerName = normalize(data.dataLayerName) || 'dataLayer';
  const eventName = normalize(data.eventName) || 'page_view';
  const pageLocation = normalize(getUrl());
  const pagePath = buildPagePath();
  const pageTitle = normalize(readTitle());

  if (!pageLocation) {
    log('Skipped because page_location was empty.');
    data.gtmOnFailure();
    return;
  }

  if (data.preventDuplicateLocation === true) {
    const previousLocation = templateStorage.getItem(STORAGE_KEY);
    if (previousLocation === pageLocation) {
      log('Skipped duplicate page_location.', pageLocation);
      data.gtmOnSuccess();
      return;
    }
    templateStorage.setItem(STORAGE_KEY, pageLocation);
  }

  const payload = {
    event: eventName,
    page_location: pageLocation,
    page_path: pagePath,
    page_title: pageTitle,
    virtual_pageview_source: 'gtm_spa_virtual_pageview'
  };

  if (data.includeReferrer === true) {
    const referrer = normalize(data.pageReferrer);
    if (referrer) {
      payload.page_referrer = referrer;
    }
  }

  const push = createQueue(dataLayerName);
  push(payload);
  log('Pushed payload.', payload);
  data.gtmOnSuccess();
};

if (data.deferRead === true) {
  callLater(pushPageview);
} else {
  pushPageview();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_title",
        "versionId": "1"
      },
      "param": []
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": false
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "dataLayer" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Community-ready template for SPA and headless virtual pageview dataLayer pushes.
