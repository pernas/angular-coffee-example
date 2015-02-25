'use strict'
################################################################################
# Define Maybe monad
_bind = (f) -> switch this
  when Nothing then Nothing
  else f this.val

_unit = (input) ->
  Object.freeze
    val: input ? null
    bind: _bind

Nothing = _unit null

Just = (input)-> if input? then _unit input else Nothing
################################################################################

angular.module('pernas.example', [])
  .directive('example', [
      'EntropyService'
      (EntropyService) ->
        {
      # snakeCase = (input) -> input.replace /[A-Z]/g, ($1) -> "_#{$1.toLowerCase()}"
      # isEmpty = (value) ->
      #   if angular.isArray(value)
      #     return value.length is 0
      #   else if angular.isObject(value)
      #     return false for key of value when value.hasOwnProperty(key)
      #   true

        restrict: 'E'
        template: 'Hola {{nom}}, com va? tens {{punts}} punts'
        controller: [
            '$scope'
            ($scope) ->
              $scope.name = "Jaume"
              $scope.MaybeName = Just "Enric"
              $scope.nom = $scope.MaybeName.val
              $scope.entropy = EntropyService.entropy
              $scope.punts = $scope.entropy($scope.nom)
          ]
        }
  ])
  # Entropy service
  .factory 'EntropyService', ->
    H = 0
    password = ''
  
    hasLowerCase = (str) ->
      /[a-z]/.test str
  
    hasUpperCase = (str) ->
      /[A-Z]/.test str
  
    hasNumbers = (str) ->
      /[0-9]/.test str
  
    hasPunctuation = (str) ->
      /[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]/.test str
  
    badPatterns = (pass, H) ->
      patterns = [
        /^\d+$/
        /^[a-z]+\d$/
        /^[A-Z]+\d$/
        /^[a-zA-Z]+\d$/
        /^[a-z]+\d+$/
        /^[a-z]+$/
        /^[A-Z]+$/
        /^[A-Z][a-z]+$/
        /^[A-Z][a-z]+\d$/
        /^[A-Z][a-z]+\d+$/
        /^[a-z]+[._!\- @*#]$/
        /^[A-Z]+[._!\- @*#]$/
        /^[a-zA-Z]+[._!\- @*#]$/
        /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$/
        /^[a-z\-ZA-Z0-9.-]+$/
      ]
      entropy = H
      angular.forEach patterns, (pattern) ->
        if pattern.test(pass)
          entropy = entropy / 2
        return
      entropy
  
    { entropy: (pass) ->
      if angular.isUndefined(pass)
        H = 0
        password = ''
      else
        if pass != password
          base = 0
          password = pass
          if hasLowerCase(pass)
            base += 26
          if hasUpperCase(pass)
            base += 26
          if hasNumbers(pass)
            base += 10
          if hasPunctuation(pass)
            base += 30
          H = Math.log2(base ** pass.length)
          H = badPatterns(pass, H)
          if H > 100
            H = 100
      H
    }
