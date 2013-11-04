Array.prototype.unique= function() {
    var unique= [];
    for (var i = 0; i < this.length; i += 1) {
        if (unique.indexOf(this[i]) == -1) {
            unique.push(this[i])
        }
    }
    return unique;
};

Array.prototype.removeByItemId = function(elem) {
  var i;
  for (i = 0; i < this.length; i++) {
    if (this[i].id === elem.id) break;
  }
  this.splice(i, 1);
  return this;
}

var PayrollApp = angular.module('PayrollApp', ['ui.bootstrap', 'ngResource'])
.config(function($httpProvider){
  $httpProvider.defaults.headers.common = {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'), 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest'};
});

PayrollApp.factory('Payroll', ['$resource', function($resource) {
    return $resource('/api/payrolls/:id', {
      id: '@id'
    }, {
      update: {method:'PUT', params: {'destroy_children':true}}
    });
  }
]);

PayrollApp.factory('Employee', ['$resource', function($resource) {
    return $resource('/api/employees/:id', {
      id: '@id'
    }, {
      query:  {method:'GET', isArray:true, params: {start_date: true, end_date: true}},
      update: {method:'PUT'}
    });
  }
]);

PayrollApp.filter('toTotal', function() {
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
});

PayrollApp.filter('toDate', function() {
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
});

PayrollApp.directive('punchGroup', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    scope: {punches: '=ngModel'},
    templateUrl: 'punch-group.html',
  };
});

PayrollApp.directive('timestamp', function() {
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

PayrollApp.filter('toTime', function() {
	return function(seconds) {
		return moment.unix(seconds).format("HH:mm");
	}
});
	
PayrollApp.directive('context', [function() {
    return {
      restrict    : 'A',
      scope       : '@&', 
      compile: function compile(tElement, tAttrs, transclude) {
        return {
          post: function postLink(scope, iElement, iAttrs, controller) {
            var ul = $('#' + iAttrs.context), last = null;
            ul.css({ 'display' : 'none'});

            $(iElement).contextmenu(function(event) {
              event.preventDefault();
              //get the div.modal-content;
              var modal = event.currentTarget.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
              ul.css({
                position: "fixed",
                display: "block",
                left: event.clientX - modal.offsetLeft + 'px',
                top: event.clientY - modal.offsetTop + 'px'
              }).attr('idx', event.currentTarget.getAttribute('idx'))
							.attr('date', event.currentTarget.getAttribute('date'));
              
              last = event.timeStamp;
            });
            
            $(document).click(function(event) {
              var target = $(event.target);
              if(!target.is(".popover") && !target.parents().is(".popover")) {
                if(last === event.timeStamp)
                  return;  
                ul.css({
                  'display' : 'none'
                });
              }
            });
          }
        };
      }
    };
  }]);
  
var ModalInstanceCtrl = function ($scope, $modalInstance, slip, start_date, end_date) {

  $scope.slip = slip;
  $scope.start_date = moment(start_date);
  $scope.end_date = moment(end_date);
  $scope.dates = {};
  for (var dt = $scope.start_date; dt.diff($scope.end_date)<=0; dt.add('days', 1)){
		var punches = [];

    for (var i = 0; i < $scope.slip.punches.length; i++){
      var punch = $scope.slip.punches[i];
      var tm = moment.unix(punch.time);
      if (tm.isSame(dt, 'day')){
        punches.push(punch.time);
      }
    }
		
		$scope.dates[dt.format('YY-MM-DD')] = punches.unique();
  }
  
  $scope.ok = function () {
		var punches = [];
		for (var dt in $scope.dates){
			punches = punches.concat($scope.dates[dt]);
		}
		$scope.slip.punches = punches;
    $modalInstance.close($scope.slip);
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
  
  $scope.deletePunch = function (e) {
    var ul = $('#menu');
    var idx = ul.attr('idx');
		var dt = ul.attr('date');
		$scope.dates[dt].splice(idx, 1);
  };
  
	$scope.insertAfter = function (e) {
    var ul = $('#menu');
    var idx = ul.attr('idx');
		var dt = ul.attr('date');
		
		$scope.dates[dt].splice(idx, 0, {time: $scope.dates[dt][idx].time});
	}
	
  $scope.insertBefore = function (e) {
    var ul = $('#menu');
    var idx = ul.attr('idx');
		var dt = ul.attr('date');
		
		$scope.dates[dt].splice(idx, 0, {time: $scope.dates[dt][idx].time});
  };
  
};

PayrollApp.controller('PayrollCtrl', function PayrollCtrl($scope, $modal, Payroll, Employee) {
  $scope.dateOptions = {
    'year-format': 'yy',
    'starting-day': 1
  };

  $scope.createPayroll = function(){
    var payroll = new Payroll();
    payroll.start_date = $scope.start_date;
    payroll.end_date = $scope.end_date;
    payroll.$save(function(data){
      $scope.payrolls.push(data);
    });
  }
	
  $scope.addToPayroll = function(employee){
    var slip = new Object();
    slip.employee = employee;
    $scope.payroll.slips.push(slip);
    $scope.employees.removeByItemId(employee);
  }
  
  $scope.removeFromPayroll = function(slip){
    $scope.employees.push(slip.employee);    
    $scope.payroll.slips.removeByItemId(slip);
  }  
  
  $scope.removeFromPayroll2 = function(slip){
    Slip.delete({payroll_id: $scope.payroll.id, id:slip.id}, function(data){
      $scope.payroll.slips.removeByItemId(slip);
      $scope.employees.push(slip.employee);
    });
  }  
  
  $scope.updatePayroll = function(){
    $scope.payroll.$update({destroy_children: true}, function(data){
			console.log(data);
    });
  }
  
  $scope.deletePayroll = function(payroll){
    Payroll.delete({id: payroll.id}, function(data){
      $scope.payrolls.removeByItemId(payroll);
    });
  }
  
  $scope.initDates = function(start_date, end_date){
    $scope.start_date = new Date(start_date);
    $scope.end_date = new Date(end_date);
  }
	
	$scope.removePayrollEmployees = function(){
    if (typeof $scope.payroll != "undefined" && typeof $scope.payroll.slips != "undefined" && typeof $scope.employees != "undefined"){
      for (var i =0; i < $scope.payroll.slips.length; i++) {
        $scope.employees.removeByItemId($scope.payroll.slips[i].employee);
      }
    }
	}
	
  $scope.initEmployees = function(start_date, end_date){
		Employee.query({start_date: start_date, end_date: end_date}, function(data){
			$scope.employees = data;
			$scope.removePayrollEmployees();
		});
  }
	
  $scope.initPayroll = function(payroll_id){
		Payroll.get({'id': payroll_id}, function(data){
			$scope.payroll = data;
      for (var i =0; i < $scope.payroll.slips.length; i++) {
        $scope.payroll.slips[i].active = false;
      }
		});
  }
	
  $scope.initPayrolls = function(){
		Payroll.query(function(data){
			$scope.payrolls = data;
		});
  }

  $scope.editPunches = function(slip){
    var modalInstance = $modal.open({
      templateUrl: 'editPunches.html',
      controller: ModalInstanceCtrl,
      windowClass: 'modal-huge',
      resolve: {
        start_date:  function() {return $scope.payroll.start_date;},
        end_date:  function() {return $scope.payroll.end_date;},
        slip: function() {return slip;}
      }
    });

    modalInstance.result.then(function(returned_slip) {
			slip = returned_slip;
    }, function () {
      console.info('Modal dismissed at: ' + new Date());
    });
  }
  
  $scope.sortBy = function(tableName, fieldName){
    if (tableName == 'employee') {
      if ($scope.employeeOrderField == fieldName){
        $scope.employeeOrderField = '-'+fieldName;
      }
      else{
        $scope.employeeOrderField = fieldName;
      }
    }
    if (tableName == 'slip') {
      if ($scope.slipOrderField == fieldName){
        $scope.slipOrderField = '-'+fieldName;
      }
      else{
        $scope.slipOrderField = fieldName;
      }
    }    
  }
  
  $scope.balanced = function(slip){
    if (slip.work_hour == slip.r_work_hour) return "warning";
    return "danger";
  }
  
  $scope.employeeOrderField = "-num";
  $scope.slipOrderField = "-num";
  
  
/*  
  Payroll.get({id: '526677de75313245a5f10000'}, function(data){
    $scope.payroll = data;
    $scope.payroll.name += 'xxxx!';
    $scope.payroll.$update();
  });
  
  
  var emp = new Payroll();
  emp.name = "12345";
  emp.$save();
*/  
});

