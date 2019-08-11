// Scroll handling is expensive, hence use a timer to handle infinite page
// scrolling.
//
// More details:
//
//   https://is.gd/NNVXDy
//   https://is.gd/pHJ8of
//   https://is.gd/6iOCVs

class CommentsShowMore {
  constructor () {
    this.interval = null
    this.scrolledWithComments = false
    this.commentsElement = null
  }

  // To be invoked upon a page change.
  endCommentsHandling = () => {
    this.endInterval()
    $(window).off('scroll')
    this.scrolledWithComments = false
    this.commentsElement = $('[data-behavior~=show-more-comments]')
  }

  // To be called to handle comments for the current page.
  startCommentsHandling = () => {
    // The scroll event triggers very often, so only enable it for pages that
    // need it (aka, pages that have the show-more-comments indicator).
    if (this.commentsElement.length) {
      $(window).on('scroll', () => {
        this.scrolledWithComments = true
      })
      this.startInterval()
    }
  }

  // Private functions.

  startInterval = () => {
    this.interval = setInterval(this.scrollForMoreComments, 200)
  }

  endInterval = () => {
    clearInterval(this.interval)
  }

  scrollForMoreComments = () => {
    if (!this.scrolledWithComments) {
      return
    }

    this.scrolledWithComments = false
    if (
      $(window).scrollTop() + window.innerHeight >=
      $(document).height() - 5
    ) {
      // The user has scrolled to the bottom of the page.
      this.showMoreComments()
    }
  }

  showMoreComments = () => {
    this.endInterval()
    if (this.commentsElement.length) {
      const commentsUrl = this.commentsElement.data('comments-url')
      const currentPage = Number(this.commentsElement.attr('data-current-page'))
      const totalPages = this.commentsElement.data('total-pages')
      if (currentPage < totalPages) {
        $('[data-behavior~=comments-spinner]').show()
        $.ajax({
          url: `${commentsUrl}?page=${currentPage + 1}`,
          method: 'GET',
          dataType: 'html',
          success: this.appendComments
        })
      }
    }
  }

  appendComments = comments => {
    $('[data-behavior~=comments]').append(comments)
    const currentPage = Number(this.commentsElement.attr('data-current-page'))
    this.commentsElement.attr('data-current-page', currentPage + 1)
    $('[data-behavior~=comments-spinner]').hide()
    this.startInterval()
  }
}

export default CommentsShowMore
