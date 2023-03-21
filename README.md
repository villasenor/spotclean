# spotclean

[![Travis Build Image]][Travis Build Status]

Cleanup empty playlists created as part of a migration to Spotify

**Assumptions:**

- You have `jq` and `curl` installed
- You are using a bash shell environment
- You have a [Spotify Developer Account][Spotify dev home]
- You have a [Spotify app][Spotify app creation] on that Developer account (it's easy!)
- You know your [Spotify user id][Spotify user id]
- You must already have a Spotify access token, which you can get by going through the [Spotify auth flow][Spotify auth tutorial] (maybe eventually I'll integrate the auth flow into this script)

Inspired by [The Myth of the Genius Programmer][Genius Programmer Book], I've started open sourcing things instead of waiting for perfection, and I encourage you to do so as well!

[Travis Build Status]: https://travis-ci.org/villasenor/spotclean
[Travis Build Image]: https://travis-ci.org/villasenor/spotclean.svg?branch=master
[Genius Programmer Book]: https://www.oreilly.com/library/view/team-geek/9781449329839/ch01.html
[Spotify dev home]: https://developer.spotify.com/dashboard/
[Spotify app creation]: https://developer.spotify.com/documentation/general/guides/app-settings/
[Spotify auth tutorial]: https://developer.spotify.com/documentation/general/guides/authorization-guide/
[Spotify user id]: https://developer.spotify.com/documentation/web-api/reference/users-profile/get-current-users-profile/
