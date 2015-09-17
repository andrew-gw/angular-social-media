(function(){
	var app = angular.module('entry-directives', []);

app.filter('cleanTimestamp', function() {
		return function(input) {
			// Split timestamp into [ Y, M, D, h, m, s ]
			var t = input.split(/[- :]/);
			// Apply each element to the Date function
			var d = new Date(t[0], t[1]-1, t[2], t[3], t[4], t[5]);
			return(d);
		};
	});

app.controller('EntryListController', ['$http','$scope',
		function($http, $scope) {
			$http.get('api/entries').success(function(data) {
				$scope.entries = data;
			}).error(function(data) {
				alert("Error:" + data);
			});

			$scope.star = function (entry) {
				$request = {userID: 1, entryID: entry.entryID};

				$http.post('api/star', $request)
				.success(function (data) {
					entry.starred = data.starred;
					// entry.starredCount = data.starredCount;
				})
				.error(function (data) {
					alert(data);
				});
			};
		}]);

app.controller('EntryDetailCtrl', ['$http','$scope','$routeParams',
		function($http,$scope,$routeParams) {
			$scope.entryId = $routeParams.entryId;
			$scope.comments = null;

			$http.get('api/entry/' + $scope.entryId).success(function(data) {
				$scope.entry = data;
			}).error(function(data) {
				// alert("Error:" + data);
			});

			$http.get('api/entry/' + $scope.entryId + "/comments").success(function(data) {
				$scope.comments = data;
			}).error(function(data) {
				// alert("Error:" + data);
			});

		}]);

	app.directive("entryToolbar", function() {
		return {
			restrict: "E",
			templateUrl: "template/entry-toolbar.html",
			controller: function() {
				this.tab = 0;

				this.isSet = function(checkTab) {
					return this.tab === checkTab;
				};

				this.setTab = function(activeTab) {
					this.tab = activeTab;
				};
			},
			controllerAs: "tab"
		};
	});

	app.directive("sidebarTabs", function() {
		return {
			restrict: "E",
			templateUrl: "template/sidebar-tabs.html",
			controller: function() {
				this.tab = 1;

				this.isSet = function(checkTab) {
					return this.tab === checkTab;
				};

				this.setTab = function(activeTab) {
					this.tab = activeTab;
				};
			},
			controllerAs: "tab"
		};
	});
	
})();