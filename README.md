# Yale ITS ActiveDirectory Manager

This Ruby class uses the `net-ldap` gem to connect to Yale's ActiveDirectory and manage directory objects.

## Usage

Install `bundler`:

```
gem install bundler

```

Install the application's gems:

```
bundle install 
```

Create the file `.env` to  hold the authentication information required  to bind to ActiveDirectory

```
cp .env.template .env
```

Change the values for the ActiveDirectory account name and its password:

```
sed -i 's/__svc_acct_dn__/ Service account DistinguishedName /g'
sed -i 's/__svc_pass__/ Password, escaping any special characters /g'
```

(The resulting `.env` will be ignored by `git`.)

The file `example.rb.txt` demonstrates the use of the class and its methods. Create a copy of the file as `example.rb`, make the modifications inside the file, make executable, and run:

```
bundle exec dotenv ./example.rb
```

The `dotenv` gem will load the authentication information inside `.env` into the Ruby execution environment and run `example.rb`


## Version 0.1.0

* `#dn`: Retrieves the DistinguishedName of an AD object possessing the specified sAMAccountName.
* `#create_computer`: Creates a new computer object in the specified OU and sets the managedBy attribute to the sAMAccountName of the owner.
* `#delete_computer`: Deletes the computer object matching the specified sAMAccountName.

## Version 1.0.0

New version has been recast as a module.

* `::dn`: Retrieves the DistinguishedName of an AD object possessing the specified sAMAccountName.
* `::create_computer`: Creates a new computer object in the specified OU and sets the managedBy attribute to the sAMAccountName of the owner.
* `::delete_computer`: Deletes the computer object matching the specified sAMAccountName.
