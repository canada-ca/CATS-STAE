# Microsoft Account Login

Developers of Government of Canada web applications that wish to support login
using a personal Microsoft account SHOULD use the new [v2.0 API
endpoint](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-overview)
of Microsoft’s identity platform which supports [OpenID
Connect](../protocols/OIDC-en.md). The following page provides technical details
about Microsoft’s OpenID Connect APIs:

<https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc>

Microsoft provides several SDKs and libraries for different development
languages and platforms. A list of these can be found here:

<https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-v2-libraries>

Single-page web applications can use the OpenID Connect implicit flow using a
client library. Server based applications SHOULD either use the authorization
code flow with a server middleware library, or else perform server-side
validation of ID tokens obtained by a client library.

## Initiating Microsoft Login

When invoking Microsoft Sign-In, Government of Canada applications SHOULD NOT
request permissions that they do not need. In most cases where a Microsoft
account is only being used as an anonymous credential, developers SHOULD only
specify `"openid"` in the scope option of authentication requests. In order to
meet the [ITSP
30.031](https://cyber.gc.ca/en/guidance/user-authentication-guidance-information-technology-systems-itsp30031-v3)
single sign-on window requirement, developers SHOULD also use the `max_age`
parameter with a value of 12 hours (43200 seconds) or less.

## Post-authentication processing

Server-based applications that use a browser-based OpenID Connect library MUST
use service-side code to validate ID tokens obtained from the browser. All
applications MUST also check that the ID token is no older than 5 minutes by
examining the value of the ID token’s `iat` (issued-at) timestamp.

Once the application has received and validated the ID token, a unique
identifier for the user can be found in the `sub` Subject field.

## Logout

Government of Canada web sites and applications SHOULD send an OpenID Connect
[logout
request](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc#send-a-sign-out-request)
to Microsoft’s `end_session_endpoint` when the user logs out. Support for
[single
logout](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc#single-sign-out)
is also RECCOMENDED.
