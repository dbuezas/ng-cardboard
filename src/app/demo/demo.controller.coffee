angular.module('ngCardboard')
.controller 'DemoCtrl', ($scope, Modernizr)->
	$scope.stereo = Modernizr.touch
	$scope.useIMU = Modernizr.touch
	# $scope.pan = 0
	# $scope.pitch = 0
	# $scope.distance = 0#-50
	# t=0
	# $scope.update = (dt)->
	# 	t+=dt
	# 	# $scope.distance = Math.sin(t*Math.PI/2)*10
	# 	$scope.$digest()
	# window.s=$scope;
