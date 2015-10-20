(function(){
  var app = angular.module('secretSpots', [
                                           'Devise',
                                           'uiGmapgoogle-maps'
                                           ])
    .config(function(uiGmapGoogleMapApiProvider) {
      uiGmapGoogleMapApiProvider.configure({
        key: 'AIzaSyAb4FKzgUIBNHbKfAbfwbEjJbH_ORh_WSQ',
        v: '3.20', //defaults to latest 3.X anyhow
        libraries: 'weather,geometry,visualization'
      });
    })

  app.controller('SpotsController', ['Auth', '$scope', '$http', function(Auth, $scope, $http){
    $scope.spots = [];
    $scope.map = { center: {
                           latitude: 47.6,
                           longitude: -122.3
                                         },
                          zoom: 15,
                  };

    this.centerMapOnUser = function(){
      navigator.geolocation.getCurrentPosition(function(position) {
          $scope.map.center = {
              latitude: position.coords.latitude,
              longitude: position.coords.longitude
          };
          $scope.$apply();
        }, function(error) {
          console.log(error);
        }
      );
    }

    $scope.$on('devise:login', function(event, currentUser){
      $http.get("/spots").success(function(data){
        $scope.spots = data.spots;
        $scope.map.center = { latitude: $scope.spots[0].lat,
                              longitude: $scope.spots[0].lon }
      }).error(function(data){
        console.log(data);
      });
    })
  }]);

  app.controller('signInCtrl', ['Auth', '$rootScope', '$scope', '$location', function(Auth, $rootScope, $scope, $location) {
      this.credentials = { email: '', password: '' };
      this.newUser = { email: '', password: '', password_confirmation: '' };

    $scope.showSignUp = false;

    this.signIn = function() {
      creds = this.credentials;
      this.credentials = { email: '', password: '' };

      Auth.login(creds).then(function(user) {
        alert('Successfully signed in user!')
      }, function(error) {
        console.info('Error in authenticating user!');
        alert('Error in signing in user!');
      });
    };

    this.signUp = function() {
      newCreds = this.newUser;
      this.newUser = { email: '', password: '', password_confirmation: '' };

      Auth.register(newCreds).then(function(registeredUser){
        $scope.showSignUp = false;
        Auth.currentUser().then(function(user){
          $rootScope.isAuthenticated = true;
          console.log('New user logged in');
        }, function(error){
          console.log(error)
        });
        alert('Successfully signed up!');
      }, function(error){
        console.log(error);
      });
    }
  }]);

  app.controller('sessionCtrl', ['Auth',
                                 '$http',
                                 '$scope',
                                 '$rootScope',
                                 '$location',
   function(Auth, $http, $scope, $rootScope, $location) {

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
