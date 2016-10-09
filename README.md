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

Core Technologies
-----------------
  * [Ruby] (https://www.ruby-lang.org)
  * [Ruby on Rails] (http://rubyonrails.org)
  * [PostgreSQL] (https://www.postgresql.org)
  * [Bootstrap] (https://getbootstrap.com)
  * [Puma] (http://puma.io)
  * [nginx] (https://nginx.org)
  * [Redis] (http://redis.io)
  * [Sidekiq] (http://sidekiq.org)

Significant Libraries
---------------------
  * [Font Awesome] (http://fontawesome.io)
  * [Bootswatch] (https://bootswatch.com)
  * [Kaminari] (https://github.com/amatsuda/kaminari)
  * [FriendlyId] (https://github.com/norman/friendly_id)
  * [CarrierWave] (https://github.com/carrierwaveuploader/carrierwave)
  * [Clearance] (https://github.com/thoughtbot/clearance)
  * [Rack::Attack] (https://github.com/kickstarter/rack-attack)
  * [localtime] (https://github.com/basecamp/local_time)
  * [invisible_captcha] (https://github.com/markets/invisible_captcha)
  * [obscenity] (https://github.com/tjackiw/obscenity)
  * [New Relic] (https://github.com/newrelic/rpm)
  * [Lograge] (https://github.com/roidrage/lograge)

Development Tooling
-------------------
  * [rack-mini-profiler] (http://miniprofiler.com)
  * [bullet] (https://github.com/flyerhzm/bullet)
  * [Reek] (https://github.com/troessner/reek)
  * [Rubocop] (https://github.com/bbatsov/rubocop)

Testing Framework and Tooling
-----------------------------
  * [Rspec] (http://rspec.info)
  * [Capybara] (https://github.com/jnicklas/capybara)
  * [PhantomJS] (http://phantomjs.org)
  * [Poltergeist] (https://github.com/teampoltergeist/poltergeist)

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

  * #### PostgreSQL text search
    Artist and Album search both use the PostgreSQL `@@` text search operator
    which provides support for: English dictionary stemming, multi-word search,
    stop words, and fuzzy text search for misspellings.

  * #### Auto-hide Flash messages
    Flash messages, as seen during resource creation, deletion and
    modification, will automatically hide, then be removed after 4 seconds as
    well as being user dismissible.

Why Rails?
----------
Ruby on Rails was chosen early on, from a host of possible web development
choices, due to the following appealing factors:

  * Developer happiness and enjoyment.
  * Unix based tooling, development and hosting.
  * Active communities, both locally and abroad.
  * Future employment possibilities.
  * Gateway to interesting new technologies such as Elixir and Phoenix.
