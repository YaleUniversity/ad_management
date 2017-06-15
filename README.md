# Yale ITS ActiveDirectory Management Gem

This gem is a lightweight wrapper for the `net-ldap` gem. It simplifies connection to Microsoft ActiveDirectory directory services and management of directory objects.

## Usage

### Installation

Install `bundler`:


    gem install bundler


Create a directory to hold your code, change into the directory and create a new GemFile or edit the existing Gemfile to include the following line:

    gem 'ad_management', :git => 'https://git.yale.edu/spinup/ad_management.git'

Edit your code to require the `ad_management` gem:

    require 'ad_management'

Install the `ad_management` gem by running `bundle`:

    bundle install --path ./vendor/bundle

or

    bundle update

The code can the be executed through `bundle`:

    bundle exec ./[your_code].rb


### Examples

Example code is contained in the `examples` folder. Each file illustrates basic usage.

Before executing, it is required that you create a configuration YAML file to contain AD credentials and connection information used to create an AD ldap binding. The path to this file must be specified as a parameter to the `.configure_from` method.

The template for these settings is `config\connection_settings.yml.txt`

### Development

Install `bundler`:

    gem install bundler

Clone repository:

    git clone https://git.yale.edu/spinup/ad_management.git

Change to project directory:

    cd ad_management

Build package

    bundle exec rake build


### Version

#### 0.1.0

Initial version

#### 0.2.0

Added return values for `.delete`.

#### 0.3.1

Added return values for `.create`. Added `yardoc` comments for methods. Fixed `rubocop` offenses.

#### 0.4.0

Added `.move_computer` method

#### 0.4.1

Standardized method returns; empty string returned for unsuccessful operation

#### 1.0.0

Initial release. Converted all method arguments to named keyword arguments. Minor change to `.move_computer`; if `target_cn:` of computer to be moved is unspecified, `target_cn:` defaults to value of `source_cn:`.
