π = Math.PI
angular.module('ngCardboard')
.directive 'vrContainer', (THREE)->
	scope: 
		orientation: '='
		pan: '='
		pitch: '='
		distance: '='
		
	require: ['vrContainer', '^vrScene', '?^^vrContainer']
	# double ^^ used as workaround to avoid getting this controller instead of the one of
	# the parent https://github.com/angular/angular.js/issues/4518
	restrict: 'E'
	controller: ($scope)->
		window.t ?= 0
		window.t++
		@t = window.t
		@object3d = new THREE.Object3D()
	link: ($scope, element, attribs, [vrContainer, vrScene, parentvrContainer])->
		if parentvrContainer?
			parentvrContainer.object3d.add vrContainer.object3d
		else
			vrScene.scene.add vrContainer.object3d
		controls = null				
		if $scope.orientation is 'mouse'
			controls = new THREE.OrbitControls(vrContainer.object3d, vrScene.renderer.domElement)
			controls.rotateUp Math.PI / 4
			controls.target.set vrContainer.object3d.position.x + 0.1, vrContainer.object3d.position.y, vrContainer.object3d.position.z
			controls.noZoom = true
			controls.noPan = true
		if $scope.orientation is 'imu'
			controls = new THREE.DeviceOrientationControls(vrContainer.object3d, true)
			controls.connect()
			controls.update()
		tmpEuler = new THREE.Euler()
		tmpMatrix = new THREE.Matrix4()

		$scope.$watchGroup ['distance', 'pan', 'pitch'], ()->
			return unless $scope.distance? and $scope.pan? and $scope.pitch?
			vrContainer.object3d.matrixAutoUpdate = no
			tmpEuler.set(
				$scope.pitch/180*π, 
				$scope.pan/180*π,
				0,
				'XYZ'
			)
			tmpMatrix
				.identity()
				.setPosition {x:0, y:0, z:$scope.distance}
			vrContainer.object3d.matrix
				.identity()
				.makeRotationFromEuler tmpEuler
				.multiply tmpMatrix
			vrContainer.object3d.matrixWorldNeedsUpdate = true

		offUpdate = vrScene.$on 'update', (e, dt) ->
			controls?.update dt

		vrScene.$on '$destroy', ->
			offUpdate()
			parentvrContainer?.object3d.remove vrContainerj.object3d
			controls = null

