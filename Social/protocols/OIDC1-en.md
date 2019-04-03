# OpenID Connect 1.0

OpenID Connect is an interoperable authentication protocol based on the [OAuth
2.0](OAuth2-en.md) family of specifications.

While OpenID Connect is built on the OAuth 2.0 authorization protocol,
Government of Canada web sites and applications SHOULD use OpenID Connect
instead of attempting to implement their own identity layer on top of OAuth.
Applications SHOULD obtain the user’s unique ID from an OpenID Connect identity
token, not from an OAuth access token.

There are numerous libraries and products that support OpenID Connect. A list of
these is available here:

<https://openid.net/developers/certified/>

Server-based Government of Canada web applications SHOULD either use the
authorization code flow of OpenID Connect with a server middleware library, or
else perform server-side validation of ID tokens obtained by a client
library. Single-page web applications SHOULD also use the authorization code
flow, but MAY use the implicit flow.

In most cases where a Social Login service is only being used as an anonymous
credential, developers SHOULD only specify `"openid"` in the `scope` option of
authentication requests. In order to meet the [ITSP
30.031](https://cyber.gc.ca/en/guidance/user-authentication-guidance-information-technology-systems-itsp30031-v3)
single sign-on window requirement, developers SHOULD also use the `max_age`
parameter with a value of 12 hours (43200 seconds) or less.

In order to perapre for futire integration with Sign in Canada, developers of
applications that use OpenID Connect to integrate with one or more social login
providers should also familiarize themselves with the [CATS Deployment
Profile](https://canada-ca.github.io/CATS-STAE/oidc1-en.html) of the protocol.

Additional information about OPenID Connect 1.0 can be found here:
<https://openid.net/connect>