# SPA Virtual Pageview

GTM tag template for pushing clean virtual pageview events from single-page applications.

## Overview

SPA Virtual Pageview is a Google Tag Manager custom tag template that pushes clean virtual pageview events to the dataLayer for single-page applications and headless frontends where route changes do not trigger traditional page loads.

This template pushes a virtual pageview event to the dataLayer. It does not send directly to GA4. A separate GA4 Event tag should consume the dataLayer event.

## What it does

- Reads the current page URL.
- Reads the current document title.
- Builds `page_location`, `page_path`, and `page_title` fields.
- Optionally includes `page_referrer`.
- Optionally skips duplicate `page_location` values during the current page lifetime.
- Optionally defers the read by one sandbox tick with `callLater`.

## What it does not do

- It does not send directly to GA4.
- It does not replace GA4 setup.
- It does not guarantee prevention of all duplicate pageviews.
- It does not automatically detect every SPA framework behavior.

## When to use it

- Use it with History Change triggers for SPA route changes.
- Use it when your app updates URLs without full page loads.
- Use it when you want a clean dataLayer event that a GA4 Event tag can consume.

## When not to use it

- Do not use it if GA4 Enhanced Measurement already handles your route changes correctly.
- Do not use it without reviewing duplicate pageview risk.
- Do not use it as a replacement for a GA4 Event tag.

## Setup

1. In Google Tag Manager, go to **Templates**.
2. Under **Tag Templates**, click **New**.
3. Open the three-dot menu and choose **Import**.
4. Import `template.tpl`.
5. Save the template.
6. Create a new tag using **SPA Virtual Pageview**.
7. Trigger it with a History Change trigger or a custom route-ready event.

## Configuration

### Event Name

Default:

```text
page_view
```

### Data Layer Name

Default:

```text
dataLayer
```

### Include Page Referrer

Adds `page_referrer` when a referrer value is provided.

### Prevent Duplicate Page Location

Skips the push when the same `page_location` has already been pushed by this template during the current page lifetime.

### Defer Read Until Route Update

Uses `callLater` to read URL and title after the current event completes.

### Enable Debug Logging

Logs pushed payloads and duplicate skips in supported debug environments.

## dataLayer output example

```js
{
  event: 'page_view',
  page_location: 'https://example.com/pricing?plan=pro',
  page_path: '/pricing?plan=pro',
  page_title: 'Pricing',
  page_referrer: 'https://example.com/',
  virtual_pageview_source: 'gtm_spa_virtual_pageview'
}
```

## GA4 handoff example

Create a GA4 Event tag that fires on the custom event:

```text
page_view
```

Map event parameters from dataLayer variables:

- `page_location`
- `page_path`
- `page_title`
- `page_referrer`, if used

## Duplicate pageview warning

If GA4 Enhanced Measurement pageviews are already enabled and tracking history changes, review duplicate pageview risk before using this template.

## Limitations

- This template pushes to the dataLayer only.
- Some frameworks update title or route metadata after GTM History Change fires. Use the defer option or trigger from an app-level route-ready event if needed.
- Duplicate prevention only applies to this template during the current page lifetime.

## Maintainer

Created and maintained by Tayo Kolade.

This template is part of a small collection of independent open-source Google Tag Manager utilities for general measurement and reporting use cases.

## Disclaimer

This is an independent open-source utility created for general Google Tag Manager use cases. It is not affiliated with or endorsed by Google or any third-party platform provider.
