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
  
PayrollApp.controller('PayrollCtrl', function PayrollCtrl($scope, Payroll, Employee) {
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
      $scope.payroll.employees.push(employee);
  }
	
  $scope.updatePayroll = function(){
    $scope.payroll.$update(function(data){
			console.log(data);
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
	
  $scope.initPayroll = function(id){
		Payroll.get({'id': id}, function(data){
			$scope.payroll = data;
		});
  }
	
  $scope.initPayrolls = function(){
		Payroll.query(function(data){
			$scope.payrolls = data;
		});
  }

  
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

