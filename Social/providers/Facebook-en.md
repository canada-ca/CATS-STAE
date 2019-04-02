# Facebook Login
[Facebook Login](https://developers.facebook.com/docs/facebook-login/) is a
social login service that applications can integrate with using the [OAuth 2.0
protocol](../protocols/OAuth2-en.md). Facebook recommends that web developers
use their [JavaScript
SDK](https://developers.facebook.com/docs/facebook-login/web/) to integrate with
Facebook Login.

The Facebook JavaScript SDK implements what the OAuth 2.0 standard refers to as
a public client. Public clients are:

> Clients incapable of maintaining the confidentiality of their credentials
> (e.g., clients executing on the device used by the resource owner, such as an
> installed native application or a web browser-based application), and
> incapable of secure client authentication via any other means.

Public clients such as the Facebook JavaScript SDK are well-suited to
single-page web applications that interact with the user by dynamically
rewriting the current page rather than loading entire new pages from a web
server. The OAuth 2.0 standard considers more traditional server-based web
applications to be confidential clients:

> Clients capable of maintaining the confidentiality of their credentials (e.g.,
> client implemented on a secure server with restricted access to the client
> credentials), or capable of secure client authentication using other means.

Facebook does not provide an SDK specifically for server-based web applications,
although they do provide information on how applications can use Facebook Login
without using their SDK, and there are many third-party OAuth 2.0 confidential
client implementations that can work with Facebook Login. Server-based web
applications can still use the Facebook JavaScript SDK to securely integrate
with Facebook Login however, by implementing a few additional server-side checks
described below.

Facebook publishes a list of security best practices for Facebook Login at
https://developers.facebook.com/docs/facebook-login/security. Developers of Government of Canada
web sites and applications SHOULD implement all of these.

## Initiating Facebook Login
Facebook does not provide a documented means for an application to determine
when a user was last authenticated. Developers of Government of Canada web applications SHOULD
therefore require Facebook users to reauthenticate upon every visit to their
site. Documentation on how to do this is available at
https://developers.facebook.com/docs/facebook-login/reauthentication/.

Note that the Facebook Login button plugin does not currently support forced
reauthentication. Developers will need to use the `FB.login` SDK call directly.

When invoking the Facebook login dialogue, Government of Canada applications SHOULD not request
permissions that they do not need. In most cases where Facebook Login is only
being used as an anonymous credential service, the `scope` parameter to
`FB.login` SHOULD be omitted.

ITSP 30.031 requires all authentication processes to include mitigation against
replay attacks. Applications using Facebook login can achieve this by using the
`auth_nonce` parameter of `FB.login`. For server-based web applications, the value
of the nonce MUST be both generated and validated by server-side code, never in
the browser. Nonce values SHOULD have a maximum lifetime of 5 minutes.

## Post-authentication processing
When using the Facebook JavaScript SDK with a server-based application,
developers SHOULD pay particular attention to protect their server-side code
from token hijacking attacks. This means that server-side code SHOULD never
implicitly trust authorization information it receives from the browser. Instead
it SHOULD always obtain the access token from the browser and then validate it.

For example, once a user has authenticated, the JavaScript SDK provides the
results of that authentication in an `authResponse` object that contains an
access token, along with other fields such as the authenticated user’s
application-specific `userID`. The browser can then send this data to the web
server in an HTTP request where the server-side code can use it to identify the
user. Token hijacking occurs when a malicious web page uses a similar HTTP
request to send fraudulent token information the application’s web server. In
order to protect against this type of attack:

1. The server-side code MUST only accept the access token from the browser,
   never the `userID` or any other field of the `authResponse`, and
1. The server MUST validate the access token itself by making a direct
   server-side call to the Facebook [token validation endpoint](https://developers.facebook.com/docs/facebook-login/access-tokens/debugging-and-error-handling)  and then checking
   the validation response as follows:
   * The `app_id` value in response MUST match the application’s `app_id`,
   * The `is_valid` value MUST be `"true"`,
   * The auth_nonce value generated earlier by your application MUST be less than 5 minutes old.

If token validation fails for any reason, the application SHOULD immediately log
the user out. If validation is successful, the token validation response
contains a `user_id` field that can be safely used to uniquely identify the user.
Obtaining the `user_id` in this manner is the recommended approach for
applications that do not require access to other personal information from the
user’s Facebook profile.

## Logout
Applications using Facebook Login MUST provide users a means to
[logout](https://developers.facebook.com/docs/facebook-login/web#logout). This
is a requirement of the [Facebook Platform
Policy](https://developers.facebook.com/policy/#login).
