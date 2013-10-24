var PayrollApp = angular.module('PayrollApp', ['ui.bootstrap', 'ngResource'])
.config(function($httpProvider){
  $httpProvider.defaults.headers.common = {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'), 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest'};
});

PayrollApp.factory('Payroll', ['$resource', function($resource) {
    return $resource('/api/payrolls/:id', {
      id: '@id'
    }, {
      update: {method:'PUT'}
    });
  }
]);

PayrollApp.factory('Employee', ['$resource', function($resource) {
    return $resource('/api/employees/:id', {
      id: '@id'
    }, {
      update: {method:'PUT'}
    });
  }
]);

PayrollApp.factory('Slip', ['$resource', function($resource) {
    return $resource('/api/slips/:id', {
      id: '@id'
    }, {
      update: {method:'PUT'}
    });
  }
]);
  
PayrollApp.controller('PayrollCtrl', function PayrollCtrl($scope, Payroll, Employee, Slip) {
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
    var slip = new Slip();
    //slip.employee = employee;
    slip.start_date = $scope.payroll.start_date;
    $scope.payroll.slips.push(slip);
  }
	
  $scope.updatePayroll = function(){
    $scope.payroll.$update(function(data){
			console.log(data);
    });
  }
  
  $scope.deletePayroll = function(payroll_id){
    Payroll.delete({id: payroll_id}, function(data){
      var i;
      for (i=0; i<$scope.payrolls.length; i++){
        if ($scope.payrolls[i].id == payroll_id) break;
      }
      if (i>=0 && i<$scope.payrolls.length){
        $scope.payrolls.splice(i, 1);
      }
    });
  }
  
  $scope.initDates = function(start_date, end_date){
    $scope.start_date = new Date(start_date);
    $scope.end_date = new Date(end_date);
  }
	
  $scope.initEmployees = function(){
		Employee.query(function(data){
			$scope.employees = data;
		});
  }
	
  $scope.initPayroll = function(payroll_id){
		Payroll.get({'id': payroll_id}, function(data){
			$scope.payroll = data;
		});
  }
	
  $scope.initPayrolls = function(){
		Payroll.query(function(data){
			$scope.payrolls = data;
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

