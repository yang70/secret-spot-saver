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
    $scope.spotMarkers = []
    $scope.map = { center: {
                           latitude: 47.6,
                           longitude: -122.3
                                         },
                            zoom: 15,
                  };
    $scope.windowOptions = {
      visible: false
    };

    $scope.onClick = function(model) {
        console.log("Clicked!");
        model.show = !model.show;
    };

    $scope.centerMapOnUser = function(){
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
    };

    $scope.centerOnSpot = function(spot){
      $scope.map.center = { latitude: parseFloat(spot.lat), longitude: parseFloat(spot.lon) }
    };

    $scope.initialCenter = function(){
      if($scope.spots.length == 0){
        $scope.centerMapOnUser();
      }else{
        $scope.centerOnSpot($scope.spots[0]);
      }
    };

    $scope.createMarkers = function(){
      var newMarker = {};
      for(var i = 0; i < $scope.spots.length; i++){
        newMarker.id = parseFloat($scope.spots[i].id)
        newMarker.latitude = parseFloat($scope.spots[i].lat);
        newMarker.longitude = parseFloat($scope.spots[i].lon);
        newMarker.name = $scope.spots[i].name;
        newMarker.waterType = $scope.spots[i].water_type;
        newMarker.technique = $scope.spots[i].technique;
        newMarker.createdOn = $scope.spots[i].created_at;
        newMarker.show = false;
        $scope.spotMarkers.push(newMarker);
        console.log(newMarker)
        console.log($scope.spots[i])
        newMarker = {};
      }
      console.log($scope.markers);
    }

    $scope.$on('devise:login', function(event, currentUser){
      $http.get("/spots").success(function(data){
        $scope.spots = data.spots;
        $scope.initialCenter();
        $scope.createMarkers();
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
