angular.module('ngCardboard')
.directive 'vrCamera', (THREE)->
	scope: 
		fov: '='
		eyeDistance: '@'
		stereo: '='
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
		camera = new THREE.PerspectiveCamera($scope.fov, 1, 0.001, 700)
		$scope.$watch 'fov', (newV, oldV)->
			camera.fov = newV

		camera.position.set 0, 0, 0
		
		if parentVrContainer?
			parentVrContainer.object3d.add camera
		else
			vrScene.scene.add camera
		
		vrScene.camera = camera

		controls = null
		
		lastSize = {width:0, height:0}
		offResize = vrScene.$on 'resize', (e, size)->
			lastSize = size
			camera.aspect = size.width / size.height
			effect.setSize size.width, size.height 
			camera.updateProjectionMatrix()

		stereoEffect = new THREE.StereoEffect(vrScene.renderer)
		effect = null
		$scope.$watch 'stereo', (newV, oldV)->
			if newV
				effect = stereoEffect
			else 
				effect = vrScene.renderer
			effect.setSize lastSize.width, lastSize.height 
			camera.aspect = lastSize.width / lastSize.height
			camera.updateProjectionMatrix()

		offRender = vrScene.$on 'render', (e, dt)->
			effect?.render vrScene.scene, camera
			

		$scope.$on '$destroy', ->
			parentVrContainer?.object3d.remove camera
			camera = null
			effect = null
			offResize()
			offRender()

			
