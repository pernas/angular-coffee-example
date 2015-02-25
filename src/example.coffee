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
      '$timeout'
      ($timeout) ->
        {
      # snakeCase = (input) -> input.replace /[A-Z]/g, ($1) -> "_#{$1.toLowerCase()}"
      # isEmpty = (value) ->
      #   if angular.isArray(value)
      #     return value.length is 0
      #   else if angular.isObject(value)
      #     return false for key of value when value.hasOwnProperty(key)
      #   true

        restrict: 'E'
        template: 'Hola {{name}}, com va?'
        controller: [
            '$scope'
            ($scope) ->
              $scope.name = "Jaume"
          ]
        }
  ])
