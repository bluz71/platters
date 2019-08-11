/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import AlbumForm from '../src/AlbumForm'
import AlbumTracksVisibility from '../src/AlbumTracksVisibility'
import AlbumsSelect from '../src/AlbumsSelect'
import ArtistForm from '../src/ArtistForm'
import ArtistsSelect from '../src/ArtistsSelect'
import CommentForm from '../src/CommentForm'
import CommentsShowMore from '../src/CommentsShowMore'
import UserForm from '../src/UserForm'

require('@rails/ujs').start()
require('turbolinks').start()
require('local-time').start()

// Event handlers to run once the DOM is ready.
$(() => {
  /* eslint-disable no-new */
  new AlbumForm()
  new AlbumTracksVisibility()
  new AlbumsSelect()
  new ArtistForm()
  new ArtistsSelect()
  new CommentForm()
  new UserForm()
  /* eslint-enable no-new */
})

// A variable to handle showing more comments. Will be instantiated and updated
// upon Turbolinks page navigation.
let commentsShowMore = null

// Event handlers to run once the DOM is ready and also on every page change.
$(document).on('turbolinks:load', () => {
  // Initialize Bootstrap tooltips.
  $('[data-toggle=tooltip]').tooltip()

  // Auto-hide, then remove, flash[:notice] messages.
  $('.alert-notice')
    .delay(4500)
    .fadeOut(500, () => {
      $(this).remove()
    })

  // Instantiate a comments handler if needed.
  if (!commentsShowMore) {
    commentsShowMore = new CommentsShowMore()
  }

  // End previous comments handling, we have moved to a new page.
  commentsShowMore.endCommentsHandling()

  // Start comments scroll handling for this new page.
  commentsShowMore.startCommentsHandling()
})
