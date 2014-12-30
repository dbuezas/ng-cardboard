angular.module('ngCardboard')
.directive 'vrCamera', (THREE)->
	scope: 
		fov: '='
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
		camera = new THREE.PerspectiveCamera($scope.fov, 1, 0.001, 700)
		$scope.$watch 'fov', (newV, oldV)->
			camera.fov = newV
			camera.updateProjectionMatrix()

		camera.position.set 0, 0, 0
		
		if parentVrContainer?
			parentVrContainer.object3d.add camera
		else
			vrScene.scene.add camera
		
		vrScene.camera = camera
		
		offResize = vrScene.$on 'resize', (e, size)->
			camera.aspect = size.width / size.height
			camera.updateProjectionMatrix()

		$scope.$on '$destroy', ->
			if parentVrContainer?
				parentVrContainer.object3d.remove camera
			else
				vrScene.scene.remove camera

			camera = null
			offResize()

			
