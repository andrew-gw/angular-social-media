(function() {
	var app = angular.module('timeline', ['ngRoute','ngAnimate','entry-directives']);
	
	app.config(['$routeProvider','$locationProvider',
		function($routeProvider, $locationProvider) {
			$routeProvider
			.when('/entries', {
				templateUrl: 'template/entry-list.html',
				controller: 'EntryListController'
			})
			.when('/entries/:entryId', {
				templateUrl: 'template/entry-detail.html',
				controller: 'EntryDetailCtrl'
			})
			.when('/login', {
				templateUrl: 'template/login.html',
				controller: 'LoginCtrl'
			})
			.otherwise({
				redirectTo: '/login'
			});
		}]);

	app.controller('LoginCtrl', ['$http','$scope','$window',
		function($http, $scope, $window) {
			$scope.user = {username: 'john.doe', password: 'foobar'};
			$scope.message = '';

			$scope.submit = function () {
				$http.post('api/access_token', $scope.user)
				.success(function (data, status, headers, config) {
					// $window.sessionStorage.token = data.token;
					$scope.message = data;
				})
				.error(function (data, status, headers, config) {
					// Erase the token if the user fails to log in
					// delete $window.sessionStorage.token;
					
					// Handle login errors here
					//$scope.message = 'Error: Invalid user or password';
					$scope.message = data;
				});
			};
	}]);

	app.factory('authInterceptor', function ($rootScope, $q, $window) {
  return {
    request: function (config) {
      config.headers = config.headers || {};
      if ($window.sessionStorage.token) {
        config.headers.Authorization = 'Bearer ' + $window.sessionStorage.token;
      }
      return config;
    },
    response: function (response) {
      if (response.status === 401) {
        // handle the case where the user is not authenticated
      }
      return response || $q.when(response);
    }
  };
});

app.config(function ($httpProvider) {
  $httpProvider.interceptors.push('authInterceptor');
});

	// app.directive('animateOnLoad',['$animateCss', function($animateCss) {
	// 	return {
	// 		'link': function(scope, element) {
	// 			$animateCss(element, {
	// 				'event': 'enter',
	// 				structural: true
	// 			}).start();
	// 		}
	// 	};
	// }]);
	
})();