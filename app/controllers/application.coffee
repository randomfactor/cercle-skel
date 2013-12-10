
ApplicationController = Ember.Controller.extend {
  # set up to use mozilla persona
  init: ->
    @_super()
    @set('loggedInUser', null)    # this will be set when user login succeeds
    navigator.id.watch {
      loggedInUser: null
      onlogin: (assertion) =>
        @serverLogin assertion
      onlogout: =>
        @serverLogout()
    }

  actions: {
    # action to take when user clicks on login button
    login: ->
      navigator.id.request()

    # action to take when user clicks on logout button
    logout: ->
      navigator.id.logout()
  }

  # call server to verify the persona assertion
  serverLogin: (assertion) ->
    $.post('/auth/browserid', { assertion: assertion }).then(
      (data, textStatus, jqXHR) =>
        if data?.user?._id
          console.log "current user id: #{data.user._id}"
          @set('loggedInUser', @get('store').createRecord('user', data.user))
        else
          # login failed, so ensure no currentUser
          @set('loggedInUser', null)
          alert 'Login failed. Try again later, maybe?'
      (jqXHR, textStatus, errorThrown) =>
        alert "Login failure: #{textStatus}"
        navigator.id.logout()
    )

  # call server to reset session state
  serverLogout: ->
    $.get('/logout').then(
      (data, textStatus, jqXHR) =>
        @set('loggedInUser', null)
        console.log "current user: null"
      (jqXHR, textStatus, errorThrown) =>
        alert "Logout failure: #{textStatus}"
    )
}

`export default ApplicationController`
