# urlshorten
### Shorten long URLs ###

Intended host: 3ur.co 

example usage: `3ur.co/Polyxena` would have DNS pointing to mydomain.heroku.com/shortens/Polyxena which would do the redirect to  `http://cnn.com`

*REST endpoints:*

- SHOW route:
GET `/shortens/:slug` with or without arbitrary query params `?foo=bar`

- CREATE route:
POST `/shortens/` with `:slug` and `:full_url` in the post body `{:slug=>"Polyxena", :full_url=>"http://cnn.com"}`

- UPDATE route:
PATCH/PUT `/shortens/:slug`  with new attributes `:slug` _and/or_ `:full_url` in the body `{:slug=>"ZUES", :full_url=>"http://cnet.com"}`

- DELETE route:
DESTROY `/shortens/:slug`

TODO:
- Add Oauth and User management functionality
- Managing API versions
- General Hardening against common user/malicious error use cases
- Deploy to a heroku server and set DNS to route 'http://3ur.co' to it
