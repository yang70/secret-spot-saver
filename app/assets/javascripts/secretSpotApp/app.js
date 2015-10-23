(function(){
  var app = angular.module('secretSpots', [
                                           'Devise',
                                           'uiGmapgoogle-maps'
                                           ])
    .config(function(uiGmapGoogleMapApiProvider) {
      uiGmapGoogleMapApiProvider.configure({
        key: 'AIzaSyAb4FKzgUIBNHbKfAbfwbEjJbH_ORh_WSQ',
        v: '3.20', //defaults to latest 3.X anyhow
        libraries: 'weather,geometry,visualization,drawing'
      });
    })

  app.controller('SpotsController', ['Auth', '$scope', '$http', '$window',function(Auth, $scope, $http, $window){
    $scope.spots = [];
    $scope.currentUserId = '';
    $scope.spotModel = { user_id: '',
                         name: '',
                         lat: '',
                         lon: '',
                         water_type: '',
                         technique: '',
                         notes: '' };
    $scope.newQuick = { user_id: '',
                        name: '',
                        lat: '',
                        lon: '',
                        water_type: '',
                        technique: '',
                        notes: '' };
    $scope.spotMarkers = [];
    $scope.map = { center: {
                           latitude: 47.6,
                           longitude: -122.3
                                         },
                   zoom: 15
                  };
    $scope.windowOptions = {
      visible: false
    };

    // $scope.drawingManagerOptions = {
    //   drawingMode: google.maps.drawing.OverlayType.MARKER,
    //   drawingControl: true,
    //   drawingControlOptions: {
    //     position: google.maps.ControlPosition.TOP_CENTER,
    //     drawingModes: [
    //       google.maps.drawing.OverlayType.MARKER
    //     ]
    //   },
    //   markerOptions: {
    //     animation: google.maps.Animation.DROP
    //   }
    // };

    $scope.onClick = function(model) {
      console.log("Clicked!");
      model.show = !model.show;
      console.log($scope.currentUserEmail);
    };

    $scope.quickSpot = function(newQuick) {
      this.showQuickSpot = false;
      $scope.newQuick.user_id = $scope.currentUserId;
      $scope.newQuick.name = newQuick.name;
      $scope.newQuick.water_type = newQuick.waterType;
      $scope.newQuick.technique = newQuick.technique;
      $scope.newQuick.notes = newQuick.notes;
      navigator.geolocation.getCurrentPosition(function(position) {
        $scope.newQuick.lat = position.coords.latitude;
        $scope.newQuick.lon = position.coords.longitude;
        $http.post("/spots", { spot: $scope.newQuick }).success(function(data){
          $scope.spots.unshift(data.spot);
          $scope.loadMarkers();
          $scope.initialCenter();
          $scope.newQuick = $scope.spotModel;
          console.log(data);
          console.log("spot created!");
        }).error(function(error, status){
          console.log(error);
          console.log(status);
        });
      });
    };

    $scope.directions = function(spot) {
      $window.open('https://www.google.com/maps/dir/Current+Location/' + spot.lat + ',' + spot.lon)
    };

    $scope.editSpot = function(spot) {
      this.showEdit = false;
      $http.patch('/spots/' + spot.id, { spot: spot }).success(function(data){
        $scope.spots.splice($scope.spots.indexOf(spot), 1, data.spot);
        $scope.loadMarkers();
      }).error(function(error, status){
        console.log(error);
        console.log(status);
      });
    }

    $scope.deleteSpot = function(spot) {
      $http({
          method: 'DELETE',
          url: '/spots/' + spot.id
        })
          .success(function() {
            console.log('spot deleted')
            $scope.spots.splice($scope.spots.indexOf(spot), 1);
            $scope.loadMarkers();
          })
          .error(function(data, status) {
            console.log(data);
            console.log(status);
          });
    };

    $scope.centerMapOnUser = function(){
      navigator.geolocation.getCurrentPosition(function(position) {
          $scope.map = { center: {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
                                 },
                         zoom: 15,
          };
          $scope.$apply();
        }, function(error) {
          console.log(error);
      });
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

    $scope.loadMarkers = function(){
      $scope.spotMarkers = [];
      var newMarker = {};
      for(var i = 0; i < $scope.spots.length; i++){
        newMarker.id = parseFloat($scope.spots[i].id)
        newMarker.latitude = parseFloat($scope.spots[i].lat);
        newMarker.longitude = parseFloat($scope.spots[i].lon);
        newMarker.name = $scope.spots[i].name;
        newMarker.waterType = $scope.spots[i].water_type;
        newMarker.technique = $scope.spots[i].technique;
        newMarker.createdOn = $scope.spots[i].created_at;
        newMarker.notes = $scope.spots[i].notes;
        newMarker.show = false;
        $scope.spotMarkers.push(newMarker);
        console.log(newMarker)
        console.log($scope.spots[i])
        newMarker = {};
      }
      console.log($scope.markers);
    }

    $scope.$on('devise:login', function(event, currentUser){
      $scope.currentUserId = currentUser.id;
      $http.get("/spots").success(function(data){
        $scope.spots = data.spots;
        $scope.initialCenter();
        $scope.loadMarkers();
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
        console.log('Successfully signed in user!');
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

    $scope.currentUserEmail = '';
    $scope.showLogout = false;

    $scope.$on('devise:login', function(event, currentUser){
      $scope.currentUserEmail = currentUser.email;
    });

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

    $scope.logout = function() {
      // var config = { headers: { 'X-HTTP-Method-Override': 'DELETE' } };
      Auth.logout().then(function(oldUser) {
        console.log('logged out')
      }, function(error) {
        alert("Error logging out.");
      });
    }
  }]);
})();
