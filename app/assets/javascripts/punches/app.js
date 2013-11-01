var PunchApp = angular.module('PunchApp', ['ui.bootstrap', 'ngResource'])
.config(function($httpProvider){
  $httpProvider.defaults.headers.common = {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'), 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest'};
});

PunchApp.factory('Punch', ['$resource', function($resource) {
    return $resource('/api/punches/:id', {
      id: '@id'
    }, {
      update: {method:'PUT', params: {'destroy_children':true}}
    });
  }
]);

PunchApp.directive('punchGroup', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    scope: {punches: '=ngModel'},
    templateUrl: 'punch-group.html',
    link: function (element, scope) {
      scope.date = "ssss";
    }
  };
});

PunchApp.directive('timestamp', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, elm, attrs, ctrl) {
      function parser(text) {
        return moment(elm.attr('date')+" "+text).unix();
      }

      function formatter(text) {
        return moment.unix(text).format("HH:mm");
      }
      
      elm.attr('date', moment.unix(scope.punch).format("YYYY-MM-DD"));
      ctrl.$parsers.push(parser);
      ctrl.$formatters.push(formatter);
    }
  };
});

var punchCtrl = function ($scope, Punch) {
  $scope.initPunches = function(){
		Punch.query(function(data){
      var punches = [];
      for (var i=0; i<data.length; i++){
        var tm = moment(data[i].time);
        punches.push(tm.unix());
      }
			$scope.punches = punches;
      $scope.date = moment.unix(punches[0]).format("YY-MM-DD");
      var total = 0;
      for (var i=0; i<punches.length; i+=2){
        if (typeof punches[i+1] != 'undefined' ){
          total = punches[i+1]-punches[i];
        }
      }
      $scope.punches.total = total;
		});
  }
  
};