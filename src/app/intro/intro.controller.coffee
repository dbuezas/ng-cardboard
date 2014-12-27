angular.module('ngCardboard')
.controller 'IntroCtrl', ($scope, $timeout)->
	$scope.isSmartphone = Modernizr.touch
	$scope.isWebGL = Modernizr.webgl
	$scope.isRightBrowser = "onorientationchange" of window and "ondeviceorientation" of window
