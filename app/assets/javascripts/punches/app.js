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
]).filter('toTotal', function() {
	return function(punches) {
    var total = 0;
    if (typeof punches != "undefined"){
      for (var i=0; i<punches.length; i+=2){
        if (typeof punches[i+1] != 'undefined' ){
          total = total + (punches[i+1].tm-punches[i].tm);
        }
      }
    }
		return total;
	}
}).filter('toDate', function() {
	return function(punches) {
    var dts = [];
    if (typeof punches != "undefined"){
      for (var i=0; i<punches.length; i++){
        var dt = moment.unix(punches[i].tm).format("YY-MM-DD");
        if (dts.indexOf(dt) == -1) dts.push(dt);
      }
    }
    if (dts.length==1) return dts[0];
		return dts;
	}
}).directive('punchesForDays', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    scope: {punches: '=ngModel'},
    templateUrl: 'punches-for-days.html',
    link: function(){
      console.log("ss");
    }
  };
}).directive('punchesForDay', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    scope: {punches: '=ngModel'},
    templateUrl: 'punches-for-day.html',
  };
}).directive('timestamp', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    //scope:{tm:'=tm'},
    link: function(scope, elm, attrs, ctrl) {
      function parser(text) {
        return moment(elm.attr('date')+" "+text).unix();
      }

      function formatter(text) {
        return moment.unix(text).format("HH:mm");
      }
      
      elm.attr('date', moment.unix(scope.punch.tm).format("YYYY-MM-DD"));
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
        punches.push({tm:tm.unix()});
      }
			$scope.punches = punches.sort(function(a,b){return a.tm - b.tm});
		});
  }
  
};