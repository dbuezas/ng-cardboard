'use strict'

angular.module('<%= appName %>')
  .filter '<%= cameledName %>', ->
    (input) ->
      '<%= cameledName %> filter: ' + input