(function(){
  var app = angular.module('secretSpots', ['Devise']);

  app.controller('SpotsController', ['$scope', '$http', function($scope, $http){
    $scope.spots = [];

    $http.get("/spots").success(function(data){
      $scope.spots = data.spots;
    }).error(function(data){
      console.log(data);
    });
  }]);

  app.controller('signInCtrl', ['Auth', '$scope', '$location', function(Auth, $scope, $location) {
      this.credentials = { email: '', password: '' };

    $scope.showSignIn = false;

    this.signIn = function() {
      // Code to use 'angular-devise' component
      Auth.login(this.credentials).then(function(user) {
        alert('Successfully signed in user!')
      }, function(error) {
        console.info('Error in authenticating user!');
        alert('Error in signing in user!');
      });
    }

    this.resetSignIn = function(){
      this.credentials = { email: '', password: '' }
    };
  }]);

  app.controller('sessionCtrl', ['Auth', '$scope', '$rootScope', '$location', function(Auth, $scope, $rootScope, $location) {

    Auth.currentUser().then(function(user){
      console.log("is authenticated");
      $rootScope.isAuthenticated = true;
    }, function(error){
      console.log(error);
    });

    $scope.$on('devise:login', function(event, currentUser){
      console.log("devise login");
      $rootScope.isAuthenticated = true;
    });

    $scope.$on('devise:new-session', function(event, currentUser){
      console.log('devise new session');
      $rootScope.isAuthenticated = true;
    });

    $scope.$on('devise:logout', function(event, oldCurrentUser){
      console.log('devise log out')
      $rootScope.isAuthenticated = false;
    });

    this.logout = function() {
      // var config = { headers: { 'X-HTTP-Method-Override': 'DELETE' } };
      Auth.logout().then(function(oldUser) {
        alert("Successfully logged out!");
      }, function(error) {
        alert("Error logging out.");
      });
    }
  }]);
})();
