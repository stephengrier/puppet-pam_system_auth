# pam_system_auth

#### Table of Contents

1. [Description](#description)
2. [Usage](#usage)
3. [Reference](#reference)
4. [Limitations](#limitations)
5. [Development](#development)

## Description

Puppet module for managing the common PAM system-auth configuration.

This module can be used to manage the common PAM authentication configuration.
This is typically system-auth/password-auth etc on Redhat systems and
common-auth etc on Debian-based systems. However, this module currently only
supports Redhat-based systems using system-auth.

This module creates a custom PAM configuration file in /etc/pam.d called
system-auth-puppet by default, and optionally symlinks the system-auth and
password-auth files to it. By default it will set a standard set of auth,
account, password and session rules, but these can also be customised via class
parameters.

## Usage
```puppet
 $auth_entries = [
   'auth        required      pam_env.so',
   'auth        sufficient    pam_unix.so try_first_pass nullok',
   'auth        required      pam_deny.so',
 ]
 $account_entries = [
   'account     required      pam_unix.so',
 ]
 $password_entries = [
   'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow',
   'password    required      pam_deny.so',
 ]
 $session_entries = [
   'session     required      pam_unix.so',
 ]
 pam_system_auth {
   auth_entries     => $auth_entries,
   account_entries  => $account_entries,
   password_entries => $password_entries,
   session_entries  => $session_entries,
 }
```

Or alternatively you can pass parameters as hieradata:

```yaml
pam_system_auth::auth_entries:
 - 'auth        required      pam_env.so'
 - 'auth        sufficient    pam_unix.so try_first_pass nullok'
 - 'auth        required      pam_deny.so'
pam_system_auth::account_entries:
 - 'account     required      pam_unix.so'
pam_system_auth::password_entries:
 - 'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow'
 - 'password    required      pam_deny.so'
pam_system_auth::session_entries:
 - 'session     required      pam_unix.so'
```

## Reference

Classes:

* [pam_system_auth](#class-pam_system_auth)
* [pam_system_auth::params](#class-pam_system_auth::params)

### Class: pam_system_auth

##### auth_entries

An array of PAM auth rules to set in the PAM system-auth configuration file.
These should be in the standard "type control module-path module-arguments"
format.
Default: see params class.

##### account_entries

An array of PAM account rules to set in the PAM system-auth configuration file.
These should be in the standard "type control module-path module-arguments"
format.
Default: see params class.

##### password_entries

An array of PAM password rules to set in the PAM system-auth configuration file.
These should be in the standard "type control module-path module-arguments"
format.
Default: see params class.

##### session_entries

An array of PAM session rules to set in the PAM system-auth configuration file.
These should be in the standard "type control module-path module-arguments"
format.
Default: see params class.

##### system_auth_target_file

The full path of the custom system-auth configuration file.
Default: /etc/pam.d/system-auth-puppet

##### system_auth_file

The full path of the standard PAM system-auth file.
Default: /etc/pam.d/system-auth

##### password_auth_file

The full path of the standard PAM password-auth file.
Default: /etc/pam.d/password-auth

##### manage_system_auth_symlink

Boolean value controlling whether or not to replace the system-auth file with
a symbolic link to the system_auth_target_file.
Default: true

##### manage_password_auth_symlink

Boolean value controlling whether or not to replace the password-auth file with
a symbolic link to the system_auth_target_file.
Default: true

##### system_auth_target_file_ensure

Value to pass to the 'ensure' parameter of the Puppet file resource for the
system_auth_target_file. Set this to 'absent' to remove it.
Default: file

## Limitations

This module currently only supports Redhat-based systems using system-auth,
password-auth etc. It has been tested on CentOS 6/7 and RHEL 6/7.

## Development

Pull requests can be made against:

https://github.com/stephengrier/puppet-pam_system_auth.git

