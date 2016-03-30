# Class: pam_system_auth
# ===========================
#
# Puppet module for managing the common PAM system-auth configuration.
# 
# This module can be used to manage the common PAM authentication configuration.
# This is typically system-auth/password-auth etc on Redhat systems and
# common-auth etc on Debian-based systems. However, this module currently only
# supports Redhat-based systems using system-auth.
# 
# This module creates a custom PAM configuration file in /etc/pam.d called
# system-auth-puppet by default, and optionally symlinks the system-auth and
# password-auth files to it. By default it will set a standard set of auth,
# account, password and session rules, but these can also be customised via
# class parameters.
#
# lint:ignore:class_inherits_from_params_class lint:ignore:80chars
#
# Examples
# --------
#
#  $auth_entries = [
#    'auth        required      pam_env.so',
#    'auth        sufficient    pam_unix.so try_first_pass nullok',
#    'auth        required      pam_deny.so',
#  ]
#  $account_entries = [
#    'account     required      pam_unix.so',
#  ]
#  $password_entries = [
#    'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow',
#    'password    required      pam_deny.so',
#  ]
#  $session_entries = [
#    'session     required      pam_unix.so',
#  ]
#  pam_system_auth {
#    auth_entries     => $auth_entries,
#    account_entries  => $account_entries,
#    password_entries => $password_entries,
#    session_entries  => $session_entries,
#  }
# 
# Or alternatively you can pass parameters as hieradata:
# 
# pam_system_auth::auth_entries:
#  - 'auth        required      pam_env.so'
#  - 'auth        sufficient    pam_unix.so try_first_pass nullok'
#  - 'auth        required      pam_deny.so'
# pam_system_auth::account_entries:
#  - 'account     required      pam_unix.so'
# pam_system_auth::password_entries:
#  - 'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow'
#  - 'password    required      pam_deny.so'
# pam_system_auth::session_entries:
#  - 'session     required      pam_unix.so'
#
# Parameters
# ----------
#
# [*auth_entries*]
#   An array of PAM auth rules to set in the PAM system-auth configuration file.
#   These should be in the standard "type control module-path module-arguments"
#   format.
#   Default: see params class.
# 
# [*account_entries*]
#   An array of PAM account rules to set in the PAM system-auth configuration
#   file. These should be in the "type control module-path module-arguments"
#   format.
#   Default: see params class.
# 
# [*password_entries*]
#   An array of PAM password rules to set in the PAM system-auth configuration
#   file. These should be in the "type control module-path module-arguments"
#   format.
#   Default: see params class.
# 
# [*session_entries*]
#   An array of PAM session rules to set in the PAM system-auth configuration
#   file. These should be in the "type control module-path module-arguments"
#   format.
#   Default: see params class.
# 
# [*system_auth_target_file*]
#   The full path of the custom system-auth configuration file.
#   Default: /etc/pam.d/system-auth-puppet
# 
# [*system_auth_file*]
#   The full path of the standard PAM system-auth file.
#   Default: /etc/pam.d/system-auth
# 
# [*password_auth_file*]
#   The full path of the standard PAM password-auth file.
#   Default: /etc/pam.d/password-auth
# 
# [*manage_system_auth_symlink*]
#   Boolean value controlling whether or not to replace the system-auth file
#   with a symbolic link to the system_auth_target_file.
#   Default: true
# 
# [*manage_password_auth_symlink*]
#   Boolean value controlling whether or not to replace the password-auth file
#   with a symbolic link to the system_auth_target_file.
#   Default: true
# 
# [*system_auth_target_file_ensure*]
#   Value to pass to the 'ensure' parameter of the Puppet file resource for the
#   system_auth_target_file. Set this to 'absent' to remove it.
#   Default: file
#
# Authors
# -------
#
# Stephen Grier
#
class pam_system_auth (
  $auth_entries = $::pam_system_auth::params::auth_entries,
  $account_entries = $::pam_system_auth::params::account_entries,
  $password_entries = $::pam_system_auth::params::password_entries,
  $session_entries = $::pam_system_auth::params::session_entries,
  $system_auth_target_file = '/etc/pam.d/system-auth-puppet',
  $system_auth_file = '/etc/pam.d/system-auth',
  $password_auth_file = '/etc/pam.d/password-auth',
  $manage_system_auth_symlink = true,
  $manage_password_auth_symlink = true,
  $system_auth_target_file_ensure = 'file',
) inherits pam_system_auth::params {

  # Make sure PAM is installed.
  $pam_package = $::pam_system_auth::params::pam_package
  if ! defined(Package[$pam_package]) {
    package { $pam_package :
      ensure => installed,
    }
  }

  # Our custom PAM system-auth configuration file.
  file { 'pam-system-auth-target-file':
    ensure  => $system_auth_target_file_ensure,
    path    => $system_auth_target_file,
    content => template('pam_system_auth/system-auth.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$pam_package],
  }

  # Symlink the default system-auth file to the target file if required.
  if $manage_system_auth_symlink == true {
    file { 'pam-system-auth-file':
      ensure  => link,
      path    => $system_auth_file,
      target  => $system_auth_target_file,
      owner   => 'root',
      group   => 'root',
      require => File['pam-system-auth-target-file'],
    }
  }
  # Symlink the default password-auth file to the target file if required.
  if $manage_password_auth_symlink == true {
    file { 'pam-password-auth-file':
      ensure  => link,
      path    => $password_auth_file,
      target  => $system_auth_target_file,
      owner   => 'root',
      group   => 'root',
      require => File['pam-system-auth-target-file'],
    }
  }

}

# lint:endignore
