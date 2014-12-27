angular.module('<%= appName %>')
.directive '<%= cameledName %>', ()->
	scope: {}
	templateUrl: 'components/<%= name %>/<%= name %>.html'
	restrict: 'E'
	link: ($scope, element, attribs)->
		#directive code here