π = Math.PI
angular.module('ngCardboard')
.directive 'vrModel', (THREE)->
	scope: 
		scale: '='
		json: '@'
		texture: '@'
	restrict: 'E'
	require: ['^vrScene', '?^vrContainer']
	link: ($scope, element, attribs, [vrScene, parentVrContainer])->
	
		loader = new THREE.JSONLoader()
		loader.load $scope.json, (geometry) ->
			material = new THREE.MeshLambertMaterial
				map: THREE.ImageUtils.loadTexture($scope.texture),
				colorAmbient: [0.480000026226044, 0.480000026226044, 0.480000026226044],
				colorDiffuse: [0.480000026226044, 0.480000026226044, 0.480000026226044],
				colorSpecular: [0.8999999761581421, 0.8999999761581421, 0.8999999761581421]

			mesh = new THREE.Mesh(geometry,	material)

			mesh.rotation.y = - Math.PI / 5;
			mesh.receiveShadow = true;
			mesh.castShadow = true;
			mesh.scale.x = $scope.scale
			mesh.scale.y = $scope.scale
			mesh.scale.z = $scope.scale

			if parentVrContainer?
				parentVrContainer.object3d.add mesh
			else
				vrScene.scene.add mesh

			light = new THREE.DirectionalLight(0xffffff);

			light.position.set(0, 100, 60);
			light.castShadow = true;
			light.shadowCameraLeft = -60;
			light.shadowCameraTop = -60;
			light.shadowCameraRight = 60;
			light.shadowCameraBottom = 60;
			light.shadowCameraNear = 1;
			light.shadowCameraFar = 1000;
			light.shadowBias = -.0001
			light.shadowMapWidth = light.shadowMapHeight = 1024;
			light.shadowDarkness = .7;
			vrScene.scene.add(light);