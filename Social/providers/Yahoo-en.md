# Yahoo Login

Yahoo supports the [OpenID Connect 1.0](../protocols/OIDC-en.md) authentication
protocol.

The following page provides technical details about Yahoo’s OpenID Connect APIs:

<https://developer.yahoo.com/oauth2/guide/openid_connect/>

Yahoo does not provide an SDK for integrating with their OpenID connect
implementation, however tere are numerous third-party libraries and products
that support OpenID Connect. A list of these is available here:

<https://openid.net/developers/certified/>

## Initiating Yahoo Sign-In

When invoking Yahoo Sign-In, Government of Canada applications SHOULD NOT
request permissions that they do not need. In most cases where a Yahoo account
is only being used as an anonymous credential, developers SHOULD only specify
`"openid"` in the `scope` option of authentication requests. In order to meet the
[ITSP
30.031](https://cyber.gc.ca/en/guidance/user-authentication-guidance-information-technology-systems-itsp30031-v3)
single sign-on window requirement, developers SHOULD also use the `max_age`
parameter with a value of 12 hours (43200 seconds) or less.

## Post-authentication processing

Server-based applications that use a browser-based OpenID Connect library MUST
use service-side code to validate ID tokens obtained from the browser. All
applications MUST also check that the ID token is no older than 5 minutes by
examining the value of the ID token’s `iat` (issued-at) timestamp.

Once the application has received and validated the ID token, a unique
identifier for the user can be found in the `sub` (Subject) field.

## Logout

Yahoo does not currently support the logout features of OpenID connect, however
it does support [OAuth 2.0 token
revocation](https://tools.ietf.org/html/rfc7009). The address of Yahoo’s token
revocation endpoint is published in their OpenID connect discovery metadata at:
<https://developer.yahoo.com/oauth2/guide/openid_connect/discovery.html.>
