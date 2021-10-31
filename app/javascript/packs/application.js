// Application imports.
import AlbumForm from '../src/AlbumForm'
import AlbumTracksVisibility from '../src/AlbumTracksVisibility'
import AlbumsSelect from '../src/AlbumsSelect'
import ArtistForm from '../src/ArtistForm'
import ArtistsSelect from '../src/ArtistsSelect'
import CommentForm from '../src/CommentForm'
import CommentsShowMore from '../src/CommentsShowMore'
import UserForm from '../src/UserForm'

// Third-party packages.
import '@hotwired/turbo-rails'

// Load stylesheets.
import '../stylesheets/application'

// jQuery import and global exposure.
const jQuery = require('jquery')
window.$ = window.jQuery = jQuery

// Legacy third-party packages.
require('bootstrap-sass/assets/javascripts/bootstrap')
require('@rails/ujs').start()
require('local-time').start()

// Load images.
require.context('../images', true, /\.(?:png|jpg|gif|ico|svg)$/)

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
// upon Turbo page navigation.
let commentsShowMore = null

// Event handlers to run once the DOM is ready and also on every page change.
$(document).on('turbo:load', () => {
  // Initialize Bootstrap tooltips.
  $('[data-toggle=tooltip]').tooltip()

  // Auto-hide, then remove, flash[:notice] messages.
  $('.alert-notice')
    .delay(4500)
    .fadeOut(500, () => {
      $(this).remove()
    })

  // Instantiate a comments handler if one does not exist.
  if (!commentsShowMore) {
    commentsShowMore = new CommentsShowMore()
  }
  // End previous comments handling, we have moved to a new page.
  commentsShowMore.endCommentsHandling()
  // Start comments scroll handling for this new page.
  commentsShowMore.startCommentsHandling()
})
