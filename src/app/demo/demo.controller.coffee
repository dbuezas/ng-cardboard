angular.module('ngCardboard')
.controller 'DemoCtrl', ($scope, Modernizr, $element)->
	$scope.stereo = Modernizr.touch
	$scope.useIMU = Modernizr.touch
	$scope.update = (dt, t)->
		$scope.holaTest	= -150+Math.sin(t%10 /10* Math.PI*2)*20
		$scope.birdsLat = 70 - (t%60 /60)%1*120
		$scope.holaScale = .8+Math.sin(t%1 * Math.PI*2)*.2
		$scope.$apply()
	window.s = $scope;
	$scope.lat = 0
	$scope.long = 0
	$scope.fov = 50