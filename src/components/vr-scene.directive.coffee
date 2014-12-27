angular.module('ngCardboard')
.directive 'vrScene', ($window, THREE, $timeout, Modernizr)->
	scope: {
		update: '&'
	}
	restrict: 'E'
	controller: ($scope)->
		@$on = $scope.$on.bind($scope)
		@$emit = $scope.$emit.bind($scope)
		@renderer = new THREE.WebGLRenderer()
		@scene = new THREE.Scene()
	link: ($scope, element, attribs, vrScene)->
	
		element.append vrScene.renderer.domElement
		clock = new THREE.Clock()
		destroyed = no
		animate = (t)->
			return if destroyed
			requestAnimationFrame animate
			deltaT = clock.getDelta()
			vrScene.$emit 'update', deltaT
			vrScene.$emit 'render', deltaT
		animate()

		vrScene.$on 'update', (e, dt)-> $scope.update(dt:dt)
		windowResize = ()->
			width = element[0].offsetWidth
			height = element[0].offsetHeight
			$scope.$emit 'resize', {width: width, height: height}
		angular.element($window).on 'resize', windowResize

		offResize = vrScene.$on 'resize', (e, size)->
			vrScene.renderer.setSize size.width, size.height
		
		$timeout ->
			windowResize()

		vrScene.$on '$destroy', ->
			angular.element($window).off 'resize', windowResize
			offResize()
			destroyed = yes
			clock = null
			$scope.renderer = null
			for obj in $scope.scene.children
				obj?.geometry?.dispose();
				obj?.material?.dispose();
				$scope.scene.remove obj
			$scope.scene = null
