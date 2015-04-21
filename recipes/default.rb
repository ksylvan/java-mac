#
# Cookbook Name:: java-mac
# Recipe:: default
#
# Author: Antek Baranski <antek.baranski@gmail.com>
#
# Copyright 2014 Antek Baranski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

header = {'Cookie' => 'oraclelicense=accept-securebackup-cookie'}

case node['java-mac']['type']
  when 'JRE'
    dmg_package 'jre-7u80-macosx-x64' do
      app 'Java 7 Update 80'
      type 'pkg'
      source   'http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jre-7u80-macosx-x64.dmg'
      checksum '43a0019cf1a365a57f5c36799b35701308036495a159eeadf9a59d94a34704d0'
      headers  header
      accept_eula true
      action   :install
    end
  when 'JDK'
    dmg_package 'jdk-7u80-macosx-x64' do
      app 'JDK 7 Update 80'
      type 'pkg'
      source   'http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-macosx-x64.dmg'
      checksum '2b9deef240a7f07d08541da01bbd60cbf93bf713efd5997e586ba23ec4f5089e'
      headers  header
      accept_eula true
      action   :install
    end
  else
    raise Chef::Exceptions::AttributeNotFound,
          ("The JAVA Mac OS X cookbook only supports JRE or JDK as the installation types")
end

# Set JAVA_HOME
bash "Set JAVA_HOME" do
  user "root"
  code <<-EOH
JAVA_HOME=$(/usr/libexec/java_home); (grep -q '^export JAVA_HOME' /etc/profile && sed -i '' 's#^export JAVA_HOME=.*#export JAVA_HOME='"$JAVA_HOME"'#' /etc/profile) || echo '\nexport JAVA_HOME='$JAVA_HOME >> /etc/profile
  EOH
end
