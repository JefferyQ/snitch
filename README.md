# Little Snitch rulesets

My [Little Snitch] rulesets for shared configurations across workstations.

| List      | Subscription URL       | Purpose                                                                                   |
| --------- | ---------------------- | ----------------------------------------------------------------------------------------- |
| Blacklist | https://bit.ly/2MQukhj | Deny HTTP(S) access to those numerous invasive services (ads, geolocation, analytics, …)  |
| Whitelist | https://bit.ly/2zK1NSk | Allow access to websites -- this is probably only usefull for me :smile:                  |
| NoUpdate  |                        | Let's me decide when applications are allowed to call home (e.g. for updates)             |

These lists need to be constantly updated... and this work has to be done manually -- or at least I have not found the algorithm
to automatically do that work! This is my procedure to detect and flag sites to be blacklisted (and whitelisted).

1.  Make sure Little Snitch is configured in _alert mode_ so as to detect all new URLs

1.  Open the website you want to visit (e.g. from a Google Search<sup>[1](#google)</sup>) -- open only on URL at a time.

1.  Allow access for _15 minutes_ to all URLs alerted by Little Snitch, except for the original URL which is considered sane and
    flagged as such, that is allow access _forever_ to the URL -- that is _host_ and _port_.

1.  By giving the _to be_ blacklisted sites temporary access, this allows us to capture redirects and other URLs that may be
    called -- this piggy back can go pretty deep sometimes.

1.  Once the page loaded, the white listed sites will be listed in the _unapproved rules_ section and all the candidate sites to
    be blacklisted will appear in the _temporary fules_ section -- or in the _expired rules_ section if the 15mn period of grace
    has expired.

1.  This is the tedious step: each site needs to be individually checked. I have a small shell script which allows me to manually
    check each URL and add it either to proper list.

1.  Once the above steps carried out, we end up with lists of domains, hosts and IP addresses that can then be dispatched in the
    appropriate files of this Git repository.

The _NoUpdate_ list is a specific. It's purpose is to prevent all applications -- including the operating
system<sup>[2](#macos)</sup>, to call home. I don't want to be geolocated, I don't want to be included in analytics of any kind,
and I don't want a forced update notification at any time of day or night. Applications are here to do their intended purpose, not
for us to become guinea pigs. Likewise I want to control when I do updates -- I plan a maintenance day twice a
year<sup>[3](#updates)</sup>.

Here again, managing updates is a manual, and sometimes tedious task, where you need to selectively disable rules in the
_NoUpdate_ ruleset to update the selected software; and once the udpate done, re-enable thos rules.

<hr>

<a name='google'><sup>1</sup></a>:
I use a custom shell script to perform Google searches, so as to strip off all the click and URL tracing.

<a name='macos'><sup>2</sup></a>: Rulesets were introduced in Little Snitch versino 4. Before that I managed the aforementioned
lists using more complex shell scripts that allowed to cut & paste rules to/from Little Snitch -- including operating system
rules. Since the introduction of these very usefull rulesets, Little Snitch has also introduced two default rulesets (i.e. _iCloud
services_, and _macOS services); I keep those rulesets disabled in most cases.

<a name='updates'><sup>3</sup></a>: Most security _experts_ say you should regularly update your software for security patches.
This is a bad practice. If you have secured your Internet connexion then you are safe. Securing my Internet connexion consists in

a) installing Little Snitch on my MacBooks,
b) only allowing SSH access from my MacBooks to other platforms (Linux, Windows), and
c) denying automated connextion from smartphones which are the most unsafe platforms in the world.

