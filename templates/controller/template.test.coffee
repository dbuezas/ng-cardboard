"use strict"
describe "controllers", ->
  scope = undefined
  beforeEach module("<%= appName %>")
  beforeEach inject(($rootScope) ->
    scope = $rootScope.$new()
    return
  )
  
  #place your tests here
  
  return
