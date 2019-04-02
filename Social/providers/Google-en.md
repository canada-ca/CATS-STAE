# Google Sign-In
[Google Sign-In](https://developers.google.com/identity/) supports the [OpenID
Connect 1.0](../protocols/OIDC1-en.md) authentication protocol. While OpenID
Connect is built on the OAuth 2.0 authorization protocol, Government of Canada web sites and
applications SHOULD use OpenID Connect instead of attempting to implement their
own identity layer on top of OAuth. Government of Canada applications SHOULD obtain the user’s
unique ID from an OpenID Connect identity token, not from an OAuth access token.

## Initiating Google Sign-In
Google’s recommended approach for initiating authentication from a web page is documented here: https://developers.google.com/identity/sign-in/web/sign-in.

When invoking Google Sign-In, Government of Canada applications SHOULD not request permissions
that they do not need. In most cases where Google Sign-In is only being used as
an anonymous credential service, developers SHOULD set the `fetch_basic_profile`
parameter of `gapi.auth2.init()` to `"false"` and only specify `"openid"` in the
scope option. In order to meet the [ITSP
30.031](https://cyber.gc.ca/en/guidance/user-authentication-guidance-information-technology-systems-itsp30031-v3)
single sign-on window requirement, developers SHOULD also use the `max_age`
parameter with a value of 12 hours (43200 seconds) or less.

## Post-authentication processing
Server-based web applications MUST verify the integrity of the ID token on the
server as documented here:
https://developers.google.com/identity/sign-in/web/backend-auth

All applications MUST also check that the ID token is no older than 5 minutes by
examining the value of the ID token’s `iat` (issued-at) timestamp.

The unique identifier for the user can be found in the `sub` (subject) field of
the validated ID token.

## Logout
Applications SHOULD log their users out as documented here:
https://developers.google.com/identity/sign-in/web/sign-in#sign_out_a_user
