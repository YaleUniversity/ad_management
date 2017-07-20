# Yale ITS ActiveDirectory Management Gem

This gem is a lightweight wrapper for the `net-ldap` gem. It simplifies connection to Microsoft ActiveDirectory directory services and management of directory objects.  There is a `AdManagement::Client` class to abstract the client connection to LDAP and each managed object can be added as modules under the `AdManagement::Objects` namespace.

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

### CLI

This gem provides the `ad` command.

```
ad help
NAME
    ad - Simple active directory object management.

USAGE
    ad [command, command, ...] [options] [arguments]

DESCRIPTION
    Provides access to active directory objects through the CLI.

COMMANDS
    computer     manage a computer object
    help         show help

OPTIONS
       --basedn=<value>           BaseDN
       --config_file=<value>      Location of a config (override env/flags)
    -h --help                     show help for this command
       --host=<value>             Active directory host
       --loglevel=<value>         Log level (debug|info|warn|error)
       --password=<value>         Password to use for Active directory bind
       --port=<value>             Active directory port
       --user=<value>             Username to use for Active directory bind
```

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

#### 2.0.0

Added a client class and cli components

#### 3.0.0

- Changed `Computer#get` to use CN instead of sAMAccountName
- Fixed `Computer#create` to create a proper computer object with userAccountControl 4096

#### 4.0.0

Changed `Computer#get` to return all attributes for a computer object

#### 4.1.0

Added methods for Computer attributes manipulation
