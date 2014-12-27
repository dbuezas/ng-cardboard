π = Math.PI
angular.module('ngCardboard')
.directive 'vrContainer', (THREE)->
	scope: 
		orientation: '='
		lat: '=' # latitude
		long: '=' # longitude
		altitude: '='
		
	require: ['vrContainer', '^vrScene', '?^^vrContainer']
	# double ^^ used as workaround to avoid getting this controller instead of the one of
	# the parent https://github.com/angular/angular.js/issues/4518
	restrict: 'E'
	controller: ($scope)->
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

		$scope.$watchGroup ['altitude', 'lat', 'long', 'roll'], ()->
			return if $scope.orientation?
			lat = $scope.lat or 0
			long = $scope.long or 0
			altitude = $scope.altitude or 0
			roll = $scope.roll or 0
			vrContainer.object3d.matrixAutoUpdate = no
			tmpEuler.set(
				long/180*π, 
				lat/180*π,
				roll/180*π,
				'XYZ'
			)
			tmpMatrix
				.identity()
				.setPosition {x:0, y:0, z:altitude}
			vrContainer.object3d.matrix
				.identity()
				.makeRotationFromEuler tmpEuler
				.multiply tmpMatrix
			vrContainer.object3d.matrixWorldNeedsUpdate = yes

		offUpdate = vrScene.$on 'update', (e, dt) ->
			controls?.update dt

		vrScene.$on '$destroy', ->
			offUpdate()
			parentvrContainer?.object3d.remove vrContainerj.object3d
			controls = null

