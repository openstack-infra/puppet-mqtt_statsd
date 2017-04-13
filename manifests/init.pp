# == Class: mqtt_statsd
#
# Full description of class mqtt_statsd here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class mqtt_statsd(
  $source_dir = '/opt/mqtt_statsd',
  $git_source_repo = 'https://git.openstack.org/openstack-infra/mqtt_statsd',
  $git_revision = 'master',
){
  include ::pip

  vcsrepo { $source_dir :
    ensure   => latest,
    provider => git,
    revision => $git_revision,
    source   => $git_source_repo,
  }

  exec { 'install_mqtt_statsd' :
    command     => "pip install -U ${source_dir}",
    path        => '/usr/local/bin:/usr/bin:/bin/',
    refreshonly => true,
    subscribe   => Vcsrepo[$source_dir],
    require     => Class['pip'],
  }

}
