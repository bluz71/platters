Platters
========

About
-----

This application, Platters, is an example web application developed using the
[Ruby on Rails web framework](http://rubyonrails.org) and associated technologies.

The Platters application is my complete album collection converted into a
database-backed web application with optional user registration, log in and
commenting components.

Platters is primarily a server-side application with sprinkles of JavaScript
(Turbolinks, jQuery, unobtrusive jQuery and CofeeScript). Note, using a
client-side JavaScript framework, such as Ember.js or React, was ruled out due
to complexity for such a small application such as this.

Build Status
------------

[![Build Status](https://travis-ci.org/bluz71/platters.svg?branch=master)](https://travis-ci.org/bluz71/platters)

Core Technologies
-----------------

* [Ruby](https://www.ruby-lang.org)
* [Ruby on Rails](http://rubyonrails.org)
* [PostgreSQL](https://www.postgresql.org)
* [Bootstrap](https://getbootstrap.com)
* [Puma](http://puma.io)
* [nginx](https://nginx.org)
* [Redis](http://redis.io)
* [Sidekiq](http://sidekiq.org)
* [Gravatar](https://gravatar.com)

Significant Ruby Libraries
--------------------------

* [Font Awesome](http://fontawesome.io)
* [Bootswatch](https://bootswatch.com)
* [Kaminari](https://github.com/amatsuda/kaminari)
* [FriendlyId](https://github.com/norman/friendly_id)
* [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
* [Clearance](https://github.com/thoughtbot/clearance)
* [Rack::Attack](https://github.com/kickstarter/rack-attack)
* [localtime](https://github.com/basecamp/local_time)
* [invisible_captcha](https://github.com/markets/invisible_captcha)
* [Rinku](https://github.com/vmg/rinku)
* [obscenity](https://github.com/tjackiw/obscenity)
* [New Relic](https://github.com/newrelic/rpm)
* [Lograge](https://github.com/roidrage/lograge)
* [Faker](https://github.com/stympy/faker)

Deployment
----------

* [DigitalOcean](https://www.digitalocean.com)
* [Ubuntu Server](http://www.ubuntu.com/server)
* [Rackspace Cloud Files](https://www.rackspace.com/en-au/cloud/files)
* [Mailgun](https://www.mailgun.com)
* [Skylight](https://skylight.io)
* [Rollbar](https://rollbar.com)
* [Namecheap](https://rollbar.com)
* [Let's Encrypt](https://letsencrypt.org)
* [Mina](http://nadarei.co/mina)
* [ruby-install](https://github.com/postmodern/ruby-install)
* [chruby](https://github.com/postmodern/chruby)
* [Fail2ban](http://www.fail2ban.org)
* [jemalloc](https://github.com/jemalloc/jemalloc)

Development Tooling
-------------------

* [Travis CI](https://travis-ci.org/bluz71/platters)
* [rack-mini-profiler](http://miniprofiler.com)
* [bullet](https://github.com/flyerhzm/bullet)
* [Brakeman](http://brakemanscanner.org)
* [Rubocop](https://github.com/bbatsov/rubocop)

Testing Framework and Tooling
-----------------------------

* [Rspec](http://rspec.info)
* [Capybara](https://github.com/jnicklas/capybara)
* [headles Chrome](https://bluz71.github.io/2017/10/01/rails-specs-using-capybara-with-headless-chrome.html)
* [Email Spec](https://github.com/email-spec/email-spec)

Miscellaneous application features
----------------------------------

* #### Busy submission buttons
All form submission buttons use the Rails Unobtrusive JavaScript (UJS)
`data-disable-with` functionality to disable, and display a spinner icon,
whilst a submitted form is being processed.

* #### Client-side form validations
Certain form elements, such as Artist name and Album title, are validated
client side for blankness in addition to traditional server-side
validation.

* #### Turbolinks 5
This Rails application uses Turbolinks for performant in-app page to page
navigation. The Turbolinks top-of-page progress bar is enabled to provide
visual feedback for page navigation that takes longer than 500ms.
Turbolinks also loads visited in-app pages from an internal transition
cache, this will result in near instant page loads for cached pages, with
later automatic page refresh if page changes have occurred. The transistion
cache is disabled only for the randomized albums page due to a jarring
effect with cover images.

* #### Turbolinks clear cache
Turbolinks.clearCache() is invoked in all JavaScript responses, that being
*js.erb* view files, where database changes occur. If not called then
inconsistent page results may be observed when using the browser back
button.

* #### PostgreSQL text search
Artist and Album search both use the PostgreSQL `@@` text search operator
which provides support for: English dictionary stemming, multi-word search,
stop words, and fuzzy text search for misspellings.

* #### Auto-hide Flash messages
Flash notice messages, as seen during resource creation, deletion and
modification, will automatically hide, then be removed after a few seconds
as well as being user dismissible.

* #### Infinite scrolling comments
Album, artist and user Comments will be displayed in bundles of 25 at a
time, newest to oldest. Scrolling to the end of a page of comments will
result in the retrieval of the next 25 comments, and so on until all
comments have been retrieved. Whilst comments are being retrieved a
spinner icon will be displayed until that batch of comments have been
appended to the page. This behaviour is modelled on Twitter infinite
scrolling.

* #### Show all / show less Album tracks
Albums with more than twenty tracks will, by default, show only the first
twenty tracks with a fade effect over the last four tracks of those twenty.
A toggle is available to show all tracks, and once selected a show less
toggle is then provided.

* #### Comment limits per-user per-day
Users are only allowed to post 100 comments per-day. This will prevent
rogue users abusing the site.

* #### Polymorphic associated comment model
Comments can be posted for artists *and* albums, hence individual comments
can belong to either an artist or album instance. Polymorphic associations
are the most elegant way to model this multi-owner relationship.

* #### Counter caches
Counter caches are a mechanism to efficiently return the number of records
through a has_many association. Using counter caches avoids the SQL COUNT
operation which is an expensive operation especially for very large tables.
Counter caches are defined for: Artist albums_count, Artist comments_count,
Album tracks_count and Album comments_count.

Why Rails?
----------
Ruby on Rails was chosen early on, from a host of possible web development
choices, due to the following appealing factors:

* Developer happiness and enjoyment.
* Unix based tooling, development and hosting.
* Active communities, both locally and abroad.
* Future employment possibilities.
* Gateway to interesting new technologies such as Elixir and Phoenix.
