# Introduction

Many social media services such as Facebook, Google and Twitter provide a login
service that can be used by third-party web sites. By supporting these social
login services, web sites provide their users with an option to authenticate
using their existing social media credentials instead of having to create a new
credential specifically for that web site.

The popularity of social login services is growing rapidly, particularly with
consumer-focused web sites and services. Users benefit from a more convenient
and streamlined login experience to third-party web sites, which in turn benefit
from increased user adoption. The use of social login services for user
authentication is not without risk however. The popularity of these services has
made them a prime target for hackers, as a compromised social login credential
can be used to gain unauthorized access to not only the owner’s social media
account, but also potentially to their accounts on third-party web sites as
well. The use of social login services also introduces new privacy
considerations, as it allows the provider of the social login service to track
users’ activity when they log into an enabled third-party web site.

## Notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in these
pages are to be interpreted as described in [BCP
14](https://tools.ietf.org/html/bcp14) when, and only when, they appear in all
capitals, as shown here.

## Policy Considerations

Before considering the use of social login, departments and agencies SHOULD
determine the assurance level requirement of the program or service being
delivered by their web site or application. The [Guideline on Defining
Authentication
Requirements](https://www.tbs-sct.gc.ca/pol/doc-eng.aspx?id=26262) describes a
process that the responsible manager can follow to determine the minimum
assurance level needed to achieve their program objectives, deliver a service or
properly execute a transaction.

The Communications Security Establishment publication [User Authentication
Guidance for Information Technology
Systems](https://cyber.gc.ca/en/guidance/user-authentication-guidance-information-technology-systems-itsp30031-v3)
provides detailed technical criteria that can be used to assess the maximum
level of credential assurance that can be achieved using a particular social
login service. A formal level of assurance assesment of popular social login
services has not yet been conducted. For the time being the use of social login
SHOULD only be considered for web sites and applications that only require level
1 credential assurance. In all cases, programs and services that require level 2
assurance or higher SHOULD use the mandatory cyber-authentication services
described in [section
3.6](https://www.tbs-sct.gc.ca/pol/doc-eng.aspx?id=26262#sec3.6) of the
Guideline on Defining Authentication Requirements.

The mandatory cyber-authentication services may add support for social login
providers in the future. In the interim, Departments and Agencies that wish to
use social login services MUST submit a proposal to the Government of Canada
Enterprise Architecture Review Board (EARB) that includes:

* a description of the digital service to which the proposal applies,
* Information on the nature and size of the service's user community,
* the required level of credential assurance, as determined by applying the
  [Guideline on Defining Authentication,
  Requirements](https://www.tbs-sct.gc.ca/pol/doc-eng.aspx?id=26262),
* the list of social login providers to be used.

## Security Considerations

All social login services provide documentation for developers that describe
security best practices for using the service. Developers SHOULD follow all of
these best practices at a minimum. With some social login services there may
also be additional security safeguards needed to meet the requirements for level
1 assurance. The additional safeguards required vary depending on the specific
social login service being used, as the different services use a variety of
different authentication protocols. Technical guidance specific to particular
social login services is provided below, however there is one common
requirement: single sign-on, which is broadly applicable to most services.

### Single Sign-on

All social login services provide support for single sign-on to third-party
applications. With single sign-on, users who have already authenticated to their
social media account are not required to re-enter their password (or satisfy
other authentication challenges) when they log in to third-parties. Single
sign-on provides convenience, but it can also be a security risk in cases where
a computer or device is shared by multiple people. In order to mitigate this
risk, single sign-on is normally subject to a timeout. The guidance provided in
section 7.3 of ITSP 30.31 specifies a maximum single sign-on window of 12 hours,
however many social media logins allow single-sign on to occur for significantly
longer than this. Because of this, Government of Canada web sites and applications SHOULD force
reauthentication of users if either:

  1. It is possible to determine that the last time the user was authenticated
     was greater than 12 hours ago, or
  2. It is not possible to determine the last time the user was authenticated.

Technical guidance on how to accomplish this with specific social login services
is provided below. In order to reduce development effort and provide a
consistent user experience however, some application developers may simply
choose to force user re-authentication on every visit to their site.

## Privacy Considerations

The privacy concerns related to social media companies are widely discussed in
the mainstream media and also documented by the Privacy Commissioner of Canada.
Departments and agencies considering the use of social login SHOULD address any
applicable concerns in a Privacy Impact Assessment. For example, enabling social
login to a Government of Canada web site or application will allow the social
login provider to collect additional information on their users such as what
social-login enabled Government of Canada web sites they visit, when, from
where, and how often.

When building the pages of Government of Canada web sites and applications that
use social login, developers SHOULD be careful not to dynamically load
JavaScript libraries or other content from third-party web sites. Third party
libraries and content are a popular mechanism used by web trackers to monitor
users’ activities online. In some cases third party libraries used by social
login-enabled sites have been used to by unscrupulous parties to gain
unauthorized access to information stored in users’ social media profile.

## Technical Guidance

The following pages provide detailed technical information for specific
authentication protocols and social login services to help developers securely
integrate them into their web site or application.

[Implementation guidance](protocols/OAuth2-en.md) for the OAuth 2.0 protocol.
Applicable to:

* [Facebook](providers/Facebook-en.md)
* [Instagram](providers/Instagram-en.md)

[Implementation guidance](protocols/OIDC1-en.md) for the OpenID Connect 1.0 protocol.
Applicable to:

* [Google](providers/Google-en.md)
* [Microsoft](providers/Microsoft-en.md)
* [Yahoo](providers/Yahoo-en.md)

[Implementation guidance](protocols/OAuth1-en.md) for the OAuth 1.0 protocol.
Applicable to:

* [Twitter](providers/Twitter-en.md)
