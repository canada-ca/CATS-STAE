# Log in with Twitter

Twitter’s [social login
service](https://developer.twitter.com/en/docs/twitter-for-websites/log-in-with-twitter/login-in-with-twitter)
uses the [OAuth 1.0](../protocols/OAuth1-en.md) protocol. Twitter does not
provide an SDK itself, but there are some third-party libraries listed on their
web site here:

 <https://developer.twitter.com/en/docs/developer-utilities/twitter-libraries>

Application developers SHOULD review and follow all of the security best practices documented on the following pages:

<https://developer.twitter.com/en/docs/basics/security-best-practices>

<https://developer.twitter.com/en/docs/basics/authentication/guides/securing-keys-and-tokens>

When registering a Government of Canada application in the Twitter developer
portal, developers SHOULD not request permissions that they do not need. The
most restrictive permission level supported by Twitter will still provide read
access to users’ tweets, home timeline, and profile information. Government of
Canada applications SHOULD not abuse the Twitter APIs to collect personal
information that is not required.

## Initiating Twitter Login

The steps to initiate login to Twitter are documented here:

<https://developer.twitter.com/en/docs/twitter-for-websites/log-in-with-twitter/guides/implementing-sign-in-with-twitter>

Twitter does not implement a single sign-on timeout so applications SHOULD
include the `force_authn` parameter with a value of `"true"` when invoking GET
oauth/authenticate.

## Post-authentication processing

Upon a successful authentication, the application’s callback_url will receive a
request containing the `oauth_token` and `oauth_verifier` parameters.
Server-based applications MUST use server-side code to verify that the token
matches the request token before proceeding to request an access token.
Server-based applications MUST also use server-side code to request the access
token.

Once the application has obtained an access token, it can use it to obtain the
user’s unique ID by calling the Twitter API `GET account/verify_credentials` and
extracting the value of `id_str`. The `GET account/verify_credentials` returns a
significant amount of personal information from the user’s Twitter profile that
is not required for credential authentication (e.g. their name, location, number
of followers, profile picture etc.). Developers can use the `include_entities`,
`skip_status`, and `include_email` parameters to supress some, but not all of
this information.

_Managers considering the use of Twitter Login for a Government of Canada
application MUST address this potential overcollection of personal information
in a Privacy Impact Assessment._

## Logout

Twitter access tokens are not explicitly expired. Government of Canada
applications MUST call the [`POST
oauth/invalidate_token`](https://developer.twitter.com/en/docs/basics/authentication/api-reference/invalidate_access_token)
to revoke their access token when a user logs off, or when their session
expires.
