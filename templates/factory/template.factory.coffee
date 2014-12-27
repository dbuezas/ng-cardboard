'use strict'

angular.module('<%= appName %>')
  .factory '<%= cameledName %>', ->
    # Service logic
    # ...

    meaningOfLife = 42

    # Public API here
    {
      someMethod: ->
        meaningOfLife
    }