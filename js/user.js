(function() {
	var app = angular.module('user', []);

	app.controller('LoginCtrl', ['$http','$scope','$window', function($http, $scope) {
		$scope.refresh = function () {
			$http.get('api/users').success(function(data) {
				$scope.users = data;
			}).error(function(data) {
				$scope.message = data;
			});
		};

		$scope.login = function () {
			
		};

		$scope.refresh();
	}]);

	app.controller('RegisterCtrl', ['$http','$scope', 'Upload', '$timeout', function($http, $scope, Upload, $timeout) {
		$scope.master = {};

		$scope.refresh = function () {
			$http.get('api/users').success(function(data) {
				$scope.users = data;
			}).error(function(data) {
				$scope.message = data;
			});
		};

		$scope.refresh();

		$scope.deleteUser = function (user) {
			$http.delete('api/user/' + user.userID)
			.success(function (data, status) {
				$scope.refresh();
				$scope.message = data;
			})
			.error(function (data, status) {
				$scope.message = data;
			});
		};

		$scope.upload = function(file) {
			file.upload = Upload.upload({
				url: 'api/user',
				data: {file: file, user: $scope.user},
			});

			file.upload.then(function (response) {
				$timeout(function () {
					$scope.message = response.data;
					$scope.user = angular.copy($scope.master);
					$scope.file = null;
					$scope.refresh();
					angular.element('#firstName').focus();
				});
			}, function (response) {
				if (response.status > 0)
					$scope.message = response.status + ': ' + response.data;
			});
		};
	}]);
	
})();