angular.module('ngCardboard')
.controller 'DemoCtrl', ($scope, Modernizr)->
	$scope.stereo = Modernizr.touch
	$scope.useIMU = Modernizr.touch
	
	window.s = $scope;
	$scope.lat = 0
	$scope.long = 0

