# Secret Spot Saver | Save your fishing locations, on the fly!

[![Stories in Ready](https://badge.waffle.io/yang70/secret-spot-saver.png?label=ready&title=Ready)](https://waffle.io/yang70/secret-spot-saver)
[![Build Status](https://travis-ci.org/yang70/secret-spot-saver.svg?branch=master)](https://travis-ci.org/yang70/secret-spot-saver)
[![Coverage Status](https://coveralls.io/repos/yang70/secret-spot-saver/badge.svg?branch=master&service=github)](https://coveralls.io/github/yang70/secret-spot-saver?branch=master)

#### An app to keep all of your favorite fishing spots securely.  See nearby locations and get directions via Google Maps integration.

by [Matthew Yang](http://matthewgyang.com)

## Description
The objective of this single page application is to be able to save information about a fishing location and the location coordinates in order to return in the future.  These locations are kept secure using an authentication and authorization system that only allows a registered user to see his/her own created spots.

Additionally the web interface was designed to be a quick single page application that utilizes AJAX calls and dynamic HTML to prevent full page refreshes.

## Technology Used
At the most basic, this application utilizes a [Ruby on Rails](http://rubyonrails.org/) back-end as an API for an [Angular.JS](https://angularjs.org) front end, single page application.

However there is a lot of other technology being used within as well which I will list here.

### Rails
I started by generating a new Rails application and modeling my resource, which I called a `Spot`.  This spot would create all the information of a location:

* Name
* Latitude
* Longitude
* Water type
* Technique
* Notes

I then generated a `SpotsController` and started creating the CRUD actions.  However because I knew this would be accessed as an API I made sure that instead or rendering views I returned a [JSON](http://www.json.org/) object.  Fortunately Rails makes this incredibly simple by allowing you to write a statment like `render json: spot`, which will convert an ActiveRecord object to JSON and package it up into a response.

### Active Model Serializers
I then utilized the [Active Model Serializers](https://github.com/rails-api/active_model_serializers) gem, which allows you to format your JSON objects to your liking, returning only the information you specify and in the format you decide.

### Angular.JS
With the API tested and passing, I moved on to the web interface of the application.  Modeling after some of my previous projects, I decided to have the [Angular.JS](https://angularjs.org) application live in the `app/assets` folder in Rails and utilize the Rails Asset Pipeline to serve it.

I generated a simple controller called `landing` whose index view would serve as the base of the application and set it to the `root` path.

### Devise

### Pundit

### Angular Devise

### Angular Google Maps
* NOT AngularJS Google Maps!!

### Angular Rails CSRF

### NGAnnotate Rails

## Testing

### Integration testing for API

### Capybara/Poltergeist for Front end
* Stub geolocation
* database_cleaner

## Documentation
* APIPIE Rails

