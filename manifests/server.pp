# Copyright 2017 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: mqtt_statsd::server

class mqtt_statsd::server (
  $mqtt_hostname,
  $statsd_hostname,
  $mqtt_port = 1883,
  $statsd_port = 8125,
){

  file { '/etc/mqtt_statsd.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('mqtt_statsd/mqtt_statsd.yaml.erb')
  }

  file { '/etc/systemd/system/mqtt_statsd.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('mqtt_statsd/mqtt_statsd.service.erb')
  }

  group {'mqtt_statsd':
    ensure => present,
  }

  user { 'mqtt_statsd':
    ensure     => present,
    home       => '/home/mqtt_statsd',
    shell      => '/bin/bash',
    gid        => 'mqtt_statsd',
    managehome => true,
    require    => Group['mqtt_statsd'],
  }

  service { 'mqtt_statsd':
    enable     => true,
    hasrestart => true,
    subscribe  => [
      File['/etc/mqtt_statsd.yaml'],
    ],
    require    => [
      File['/etc/systemd/system/mqtt_statsd.service'],
      User['mqtt_statsd'],
    ],
  }

}

