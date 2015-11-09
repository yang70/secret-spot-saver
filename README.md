# Secret Spot Saver | Save your fishing locations, on the fly!

[![Stories in Ready](https://badge.waffle.io/yang70/secret-spot-saver.png?label=ready&title=Ready)](https://waffle.io/yang70/secret-spot-saver)
[![Build Status](https://travis-ci.org/yang70/secret-spot-saver.svg?branch=master)](https://travis-ci.org/yang70/secret-spot-saver)
[![Coverage Status](https://coveralls.io/repos/yang70/secret-spot-saver/badge.svg?branch=master&service=github)](https://coveralls.io/github/yang70/secret-spot-saver?branch=master)

#### A web app to keep all of your favorite fishing spots secret and secure.  See nearby locations and get directions via Google Maps integration.

by [Matthew Yang](http://matthewgyang.com)

## Description
The objective of this single page application is to be able to save information about a fishing spot including latitude/longitude, water type, fishing technique and notes.  These locations are kept secure using an authentication and authorization system that only allows a registered user to see his/her own created spots.

Additionally the web interface was designed using AngularJS to be a quick single page application that utilizes AJAX calls to a Rails API and dynamic HTML to prevent full page refreshes.

<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/2015-11-01+12.51.17.png" width="200px" />
<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/signin-flash.PNG" width="200px" />
<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/2015-11-01+12.55.25.png" width="200px" />

<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/2015-11-01+12.54.50.png" width="200px" />
<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/2015-11-01+12.54.59.png" width="200px" />
<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/2015-11-01+12.54.27.png" width="200px" />

## Technology Used
At the most basic, this application utilizes a [Ruby on Rails](http://rubyonrails.org/) back-end as an API for an [Angular.JS](https://angularjs.org) front end, single page application.

However there is a lot of other technology incorporated to make this work (relatively) smoothly.

### Rails
I started by generating a new Rails application and modeling my resource, which I called a `Spot`.  This spot would contain all the information of a location:

* Name
* Latitude
* Longitude
* Water type
* Technique
* Notes

I then generated a `SpotsController` and started creating the CRUD actions.  However because I knew this would be accessed as an API I made sure that instead or rendering views I returned a [JSON](http://www.json.org/) object.  Fortunately Rails makes this incredibly simple by allowing you to write a statment like `render json: spot`, which will convert an ActiveRecord object to JSON and package it up into a response.

**NOTE:**
I considered using an API versioning strategy like I discussed in my [blog](http://www.matthewgyang.com/articles/5), however with limited time to get this up and running I left that as a future refactor.

### Active Model Serializers
I then utilized the [Active Model Serializers](https://github.com/rails-api/active_model_serializers) gem, which allows you to format your JSON objects to your liking, returning only the information you specify and in the format you decide.

```ruby
# app/serializers/spot_serializer.rb
class SpotsSerializer < ActiveModel::Serializer
  attributes :id,
           :user_id,
           :name,
           :lat,
           :lon,
           :water_type,
           :technique,
           :notes,
           :created_at,
           :updated_at
end
```

### Angular.JS
With the API tested and passing, I moved on to the web interface of the application.  Modeling after some of my previous projects, I decided to have the [Angular.JS](https://angularjs.org) application live in the `app/assets` folder in Rails and utilize the Rails Asset Pipeline to serve it.

I generated a simple controller called `landing` whose index view would serve as the base of the application and set it to the `root` path.

I then started outlining an HTML framework based on some UI design drawings I had sketched up earlier.  In order to minimize page refreshes and take advantage of Angular's client side MVC efficiency, I incorporated a number of `ng-hide` and `ng-show` in order to make the page feel dynamic without having to actually refresh any HTML.

For the JavaScript, I created controllers for the major actions which incorporate AJAX requests to the Rails API:

* Sign in
* Sessions
* Spots

I was able to create a welcome/sign in page, sign up page and a main application page that dynamically changes for spot addition/deletion/edit.

### Devise / Angular Devise
[Devise](https://github.com/plataformatec/devise) on the Rails side is very straightforward and smooth when following the directions in the README and I had it up and running within an hour.

As far as integrating Devise (current user, user sessions, authentication) into Angular, luckily I had recently accomplished this in a previous project.

I installed the [Angular Devise](https://github.com/cloudspace/angular_devise) JavaScript library and incorporated a strategy of a now-defunct blog post to set up a sign in controller and a session controller.


### Pundit
I incorporated the [Pundit gem](https://github.com/elabs/pundit) for authorization and developed a simple `spot` policy which is stored in `app/policies`.  Through simple integration in the controllers, you can verify that only authorized information is returned during an AJAX request:

```ruby
# index action from app/controllers/spots_controller.rb
def index
  spots = policy_scope(Spot)
  render json: spots, status: 200
end
```

### Angular Google Maps
I used the following JS library called [Angular Google Maps](http://angular-ui.github.io/angular-google-maps/) in order to incorporate maps into my application.  The documentation is fairly easy to follow for basic operations, however it took a lot of trial and error to get more advanced features working.

Eventually I was able to get the map to appear and show previously created spots as well as create a new spot given the user's current location by utilizing the HTML5 `navigator.geolocation` JS object API of modern web browsers.

This information was then successfully saved via the API and redisplayed via AJAX calls.

**NOTE:**
As of this writing, one of the main features I planned during design of being able to add a spot location after the fact (not current location) is not working.  After spending almost a full day trying to get it working I decided to move on, especially since the core of the this application was created in a 4 day time-frame.

### Angular Flash
Flash messages have been incorporated using [Angular Flash](https://github.com/wmluke/angular-flash).

<img src="https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/signin-flash.PNG" width="200px" />

Here's an example of the JavaScript for displaying an error message:

```javascript
...
}, function(error){
  $.each(error.data.errors, function(index, value) {
    errorMsg += (index + ' ' + value + ': ');
  })
  flash.to('signup-alert').error = errorMsg;
});
```

### Angular Rails CSRF
In order to access the built in [Angular Cross Site Request Forgery](https://docs.angularjs.org/api/ng/service/$http) I added the [Angular Rails CSRF gem](https://github.com/jsanders/angular_rails_csrf) that will send the token in a header.

One obstacle that I again had encountered in a previous Rails/Angular application was an issue with the CSRF token being invalidated after a Devise log in.  See my [blog post](http://www.matthewgyang.com/articles/6) about this for more information on the work-around.

### NGAnnotate Rails
When serving Angular code from a Rails application using the Rails Asset Pipeline, you run into issues when the code is minified.  In order to get around this I installed the [NGAnnotate Rails gem](https://github.com/kikonen/ngannotate-rails), which is a gem version of [NG Annotate](https://github.com/olov/ng-annotate).

### Background Jobs (Sidekiq/Redis/Sendgrid)
[ActionMailer](http://guides.rubyonrails.org/action_mailer_basics.html) has been configured along with [Sidekiq](https://github.com/mperham/sidekiq) (which uses [Redis](http://redis.io/)) and [Sendgrid](https://sendgrid.com/) on [Heroku](https://dashboard.heroku.com/) to send a welcome email to new users on successful registration.  It also sends a notification email to myself advising of a new registration.

This is done in a background job by creating a Sidekiq worker and calling that worker to execute asynchronously after yielding to `super` in the `registrations_controller.rb` that was generated from devise.

I also followed [these](https://coderwall.com/p/fprnhg/free-background-jobs-on-heroku) instructions to use the Unicorn server on Heroku and generate workers within the same dyno (therefore free) instead of requiring a second dyno.

### Styling
For this project I incorporated [Bootstrap](http://getbootstrap.com/) in order to make it mobile focused with large buttons and layout.

## Testing
I committed to have a full test suite for the entire application.  Current test coverage via Coveralls:  [![Coverage Status](https://coveralls.io/repos/yang70/secret-spot-saver/badge.svg?branch=master&service=github)](https://coveralls.io/github/yang70/secret-spot-saver?branch=master)

### Integration testing for API
I have standard Rack integration tests for the API portion of the application which is testing all CRUD actions including Authentication/Authorization.

### Capybara/Poltergeist for Front end
The Angular side of the application is tested via a JavaScript enabled headless browser, in this case [Capybara](https://github.com/jnicklas/capybara) with [Poltergeist(Phantom JS)](https://github.com/teampoltergeist/poltergeist) as the driver.

The main hurdle I overcame here was how to simulate a call to `navigator.geolocation`.  I got around this using the method described [here](http://collectiveidea.com/blog/archives/2014/01/21/mocking-html5-apis-using-phantomjs-extensions/) and mocking that object with the following:

```javascript
// test/phantomjs_ext/geolocation.js
navigator.geolocation =
{
  getCurrentPosition: function(callback) {
    callback({ coords: { latitude: "47.62332381", longitude: "-122.3360773" } });
  }
}
```

This way during the test run, calling to that object will return a properly formatted response.

## Documentation
At the last minute I also decided to try out an API documentation gem called [APIPIE](https://github.com/Apipie/apipie-rails), which allows you to generate documentation for accessing your API within your code.  The results can be seen here:

[documentation](https://s3-us-west-2.amazonaws.com/spot-saver/readme-images/documentation.html)

