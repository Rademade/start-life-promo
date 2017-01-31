app.controller 'profileController', [
  'Selector', 'Country', 'Language', 'User', 'Account', '$state', 'synchronization',
  (Selector, Country, Language, User, Account, $state, synchronization) ->

    @user = synchronization.getUser()
    @accounts = synchronization.getSocialAccounts()
    @sexes = synchronization.getSexes()

    @editingUser = {}
    @isFormSubmitted = no
    @isRecFormSubmitted = no
    @error = ''

    @toggleAccount = (account) ->
      key = account.key
      if @isConnected(key)
        account = _.find @editingUser.accounts, (account) -> account.provider is key
        new Account(id : account.id).delete().then () =>
          @init()
      else
        SocialWindow.open(key)

    @init = ->
      if synchronization.isLogined()
        @setUpUser(@user.id)
      else
        $state.go 'index.log-reg'

    @setUpUser = (userId) ->
      User.get(userId).then (user) =>
        synchronization.setUser(user)
        @editingUser = user
        @editingUser.id = userId
        @setUpCountry(user)
        @setUpLanguage(user)
        @prepareForm()

    @setUpCountry = (user) ->
      Country.getAll().then (countries) =>
        country = if user.country then name : user.country else countries[0]
        @countriesSelector = new Selector(countries, country)

    @setUpLanguage = (user) ->
      Language.getAll().then (languages) =>
        language = if user.language then name : user.language else languages[0]
        @languagesSelector = new Selector(languages, language)

    @prepareForm = ->
      @setSex(synchronization.getSex())
      @setBirthday() if @editingUser.birthday

    @setSex = (name) ->
      _.each @sexes, (sex) ->
        sex.active = sex.name is name
        yes

    @setBirthday = ->
      date = new Date(@editingUser.birthday)
      @year = date.getFullYear()
      @month = date.getMonth() + 1
      @day = date.getDate()

    @openDeleteProfilePopup = ->
      @deleteProfilePopup = yes

    @sentDeleteConfirmation = ->
      User.deletion_confirmation(@user).then () ->
        $state.go 'public.profile.edit.delete-popup-check'

    @logoutUser = () ->
      synchronization.reset()
      $state.go 'index.log-reg'

    window.addEventListener 'message', (event) =>
      for key, key_args of event.data
        switch key
          when 'userId' then  @init(); break

    @isConnected = (key) ->
      synchronization.isConnectedToSocialAccount(key)

    @save = (isValid) ->
      @isFormSubmitted = yes

      sex = @sexes[0].active is yes
      birthday = if @year && @month && @day then new Date(@year, @month - 1, @day) else null
      firstName = @editingUser.name.split(' ')[0] if @editingUser.name
      lastName = @editingUser.name.split(' ')[1] if @editingUser.name
      country = @countriesSelector.selected?.name if @countriesSelector
      language = @languagesSelector.selected?.name if @languagesSelector

      @setUpParams(sex, birthday, firstName, lastName, country, language)

      if isValid
        @editingUser.save().then (user) =>
          @init()
          @isFormSubmitted = no

    @setUpParams = (sex, birthday, firstName, lastName, country, language) ->
      @editingUser.sex = sex
      @editingUser.birthday = birthday
      @editingUser.firstName = firstName
      @editingUser.lastName = lastName
      @editingUser.country = country
      @editingUser.language = language

    @hasError = (field, error) ->
      @isFormSubmitted && field.$error[error]

    @isMatchPassword = ->
      @editingUser and @editingUser.password is @editingUser.repeatPassword

    @isPasswordRepeatError = (form) ->
      (!form.repeatPassword.$valid || @isMatchPassword()) && @isFormSubmitted

    @submit = (isValid) ->
      @isRecFormSubmitted = yes
      return unless isValid && @isMatchRecPassword()
      params =
        id : synchronization.getUserId()
        password : @changeUserPass.password
      User.change_password(params)
      $state.go 'public.profile.edit.successfully-changed'

    @clearError = () ->
      @error = ''
      @isRecFormSubmitted = no

    @isMatchRecPassword = ->
      @changeUserPass && @changeUserPass.password is @changeUserPass.repeatPassword

    @init()

    return

]
