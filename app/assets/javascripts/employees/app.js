var employeeApp = angular.module('employeeApp', ['ui.bootstrap', 'ngResource'])
.config(function($httpProvider){
  $httpProvider.defaults.headers.common = {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'), 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest'};
});

employeeApp.factory('Employee', ['$resource', function($resource) {
    return $resource('/employees/:id', {
      id: '@id'
    }, {
      update: {method:'PUT'}
    });
  }
]);

  
/*  
employeeApp.factory('Employee', function($resource) {
  var Employee;
  return Employee = (function() {

    function Employee() {
      this.service = $resource('employees/:id', {
        id: '@id'
      });
    }

    Employee.prototype.create = function(attrs) {
      new this.service({
        employee: attrs
      }).$save(function(employee) {
        return attrs.id = employee.id;
      });
      return attrs;
    };

    Employee.prototype.all = function() {
      return this.service.query();
    };

    return Employee;

  })();
});
*/
employeeApp.controller('employeeCtrl', function EmployeeCtrl($scope, Employee) {
  Employee.query(function(data){
    $scope.employees = data;
  });
  
  Employee.get({id: '526677de75313245a5f10000'}, function(data){
    $scope.employee = data;
    $scope.employee.name += 'xxxx!';
    $scope.employee.$update();
  });
  
  
  var emp = new Employee();
  emp.name = "12345";
  emp.$save();
});

