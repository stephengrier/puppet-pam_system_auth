# Params class.
# lint:ignore:80chars

class pam_system_auth::params {

  # The name of the pam package.
  $pam_package = 'pam'

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '6': {
          $auth_entries = [
            'auth        required      pam_env.so',
            'auth        sufficient    pam_unix.so try_first_pass nullok',
            'auth        requisite     pam_succeed_if.so uid >= 500 quiet',
            'auth        required      pam_deny.so',
          ]
          $account_entries = [
            'account     required      pam_unix.so',
            'account     sufficient    pam_succeed_if.so uid < 500 quiet',
            'account     required      pam_permit.so',
          ]
          $password_entries = [
            'password    requisite     pam_cracklib.so try_first_pass retry=3',
            'password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok',
            'password    required      pam_deny.so',
          ]
          $session_entries = [
            'session     optional      pam_keyinit.so revoke',
            'session     required      pam_limits.so',
            'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
            'session     required      pam_unix.so',
          ]
        }
        '7': {
          $auth_entries = [
            'auth        required      pam_env.so',
            'auth        sufficient    pam_unix.so nullok try_first_pass',
            'auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success',
            'auth        required      pam_deny.so',
          ]
          $account_entries = [
            'account     required      pam_unix.so',
            'account     sufficient    pam_localuser.so',
            'account     sufficient    pam_succeed_if.so uid < 1000 quiet',
            'account     required      pam_permit.so',
          ]
          $password_entries = [
            'password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=',
            'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow',
            'password    required      pam_deny.so',
          ]
          $session_entries = [
            'session     optional      pam_keyinit.so revoke',
            'session     required      pam_limits.so',
            '-session     optional      pam_systemd.so',
            'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
            'session     required      pam_unix.so',
          ]
        }
        default: {
          $auth_entries = [
            'auth        required      pam_env.so',
            'auth        sufficient    pam_unix.so try_first_pass nullok',
            'auth        required      pam_deny.so',
          ]
          $account_entries = [
            'account     required      pam_unix.so',
          ]
          $password_entries = [
            'password    requisite     pam_cracklib.so try_first_pass retry=3 type=',
            'password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow',
            'password    required      pam_deny.so',
          ]
          $session_entries = [
            'session     optional      pam_keyinit.so revoke',
            'session     required      pam_limits.so',
            'session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid',
            'session     required      pam_unix.so',
          ]
        }
      }
    }
    default: {
      fail {"pam_system_auth is not supported on ${::osfamily}":}
    }
  }

}

# lint:endignore
