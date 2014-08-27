# Capture Dashboard

This is a monitoring Dashboard to provide a view into teh status of the Capture API. It has several sections to show the status of different dependencies of Capture API.

### Health Check

This is a display of information from the health check for Capture API. It pulls JSON from the health check service (<domain name>/capture_api/health.json) and displays it in the "Health Check" section on the dashboard. It will dynamically display any information given in the dependency list returned as long as it conforms to ReachLocal's health check standards (https://info.reachlocal.com/display/TECH/REST+API+Guidelines#RESTAPIGuidelines-HealthCheck).

### Resque

This is a display of information from the resque health check for Capture API. It pulls JSON from the health check service (<domain name>/capture_api/resque_health.json) and displays it in the "Resque" section on the dashboard.

### Airbrake

This is a display fo information from Cature's airbrake account. It will display the 5 most recent errors, and the 5 most frequest errors, in the "Airbrake" section on the dashboard.

## Environment Setups

### Homebrew

We currently use [Homebrew](http://brew.sh/) on our Mac OS X boxes to install and manage our OS Level dependencies. If you don't have [Homebrew](http://brew.sh/) installed yet, INSTALL IT!.

### Git & Our Repository

We use [git](http://gitscm.com/) for our source control management system. Therefore, to obtain the code or interact with you code you will of course need [git](http://gitscm.com/). We recommend installing [git](http://gitscm.com/) via [Homebrew](http://brew.sh/) on Mac OS X because it is as simple as `brew install git`.

Once you have [git](http://gitscm.com/) installed properly you should be able to clone the repository with the following command.

    ssh://git@stash.lax.reachlocal.com/cap/capture_crawler_api.git

The above of course assumes that you have a [Stash](https://stash.lax.reachlocal.com) account and that your public keys are correctly placed in your [Stash](https://stash.lax.reachlocal.com/) profile.

### Ruby Version Setup

In our projects we use [RVM](http://rvm.io/) to manage our ruby environment. A `.ruby-version` file is provided to set the correct version of ruby and to create a project specific gemset that all gems will be installed into.

## Running Tests

This project has been written from the ground up with tests using BDD.  Therefore, there are a few different ways to run tests. These can be found below.

#### Cucumber (Full-Stack Integration Tests)

To run the full suite of Full-Stack Integration Tests simply run the following command:

    bundle exec cucumber features/

#### RSpec (Integration & Isolation Tests)

To run the full suite of RSpec level integration and isolation tests simply run the following command:

    bundle exec rspec spec/

