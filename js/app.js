(function() {
	var app = angular.module('timeline', ['ngRoute','user','entry','ngFileUpload']);
	
	app.config(['$routeProvider','$locationProvider', function($routeProvider, $locationProvider) {
		$routeProvider
		.when('/entries', {
			templateUrl: 'template/entry-list.html',
			controller: 'EntryListController'
		})
		.when('/entries/:entryId', {
			templateUrl: 'template/entry-detail.html',
			controller: 'EntryDetailCtrl'
		})
		.when('/register', {
			templateUrl: 'template/register.html',
			controller: 'RegisterCtrl'
		})
		.when('/login', {
			templateUrl: 'template/login.html',
			controller: 'LoginCtrl'
		})
		.otherwise({
			redirectTo: '/login'
		});
	}]);

	// Prevents IE/Edge from caching AJAX requests
	app.config(['$httpProvider', function ($httpProvider) {
		if (!$httpProvider.defaults.headers.get) {
			$httpProvider.defaults.headers.get = {};
		}
		$httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
		$httpProvider.defaults.headers.get['If-Modified-Since'] = '0';
	}]);

// 	app.factory('authInterceptor', function ($rootScope, $q, $window) {
//   return {
//     request: function (config) {
//       config.headers = config.headers || {};
//       if ($window.sessionStorage.token) {
//         config.headers.Authorization = 'Bearer ' + $window.sessionStorage.token;
//       }
//       return config;
//     },
//     response: function (response) {
//       if (response.status === 401) {
//         // handle the case where the user is not authenticated
//       }
//       return response || $q.when(response);
//     }
//   };
// });

// app.config(function ($httpProvider) {
//   $httpProvider.interceptors.push('authInterceptor');
// });
	
})();