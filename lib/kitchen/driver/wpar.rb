# -*- encoding: utf-8 -*-
#
# Author:: Alain Dejoux (<adejoux@djouxtech.net>)
#
# Copyright (C) 2016, Alain Dejoux
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'kitchen'
require 'kitchen/driver/wpar_version'
require 'net/ssh'

module Kitchen

  module Driver

    # Wpar driver for Kitchen.
    #
    # @author Alain Dejoux <adejoux@djouxtech.net>
    # noinspection RubyDefParenthesesInspection,SpellCheckingInspection
    class Wpar < Kitchen::Driver::Base

      kitchen_driver_api_version 2
      plugin_version Kitchen::Driver::WPAR_VERSION

      default_config :mkwpar, '/usr/sbin/mkwpar'
      default_config :startwpar, '/usr/sbin/startwpar'
      default_config :rmwpar, '/usr/sbin/rmwpar'
      default_config :lswpar, '/usr/sbin/lswpar'
      default_config :wpar_name, 'kitchenwpar'
      default_config :aix_host, 'localhost'
      default_config :aix_user, 'root'
      default_config :isWritable, false

      def create(state)
        if wpar_exists?(state)
          raise ActionFailed, 'wpar already exists !'
        end

        cmd = build_mkwpar_command()
        ssh_command(cmd, :stderr)

        unless wpar_exists?(state)
          raise ActionFailed, 'Cannot create wpar !'
        end
        state[:hostname]= config[:wpar_address] || config[:wpar_name]
        copy_key()
      end

      def destroy(state)
        ssh_command("#{config[:rmwpar]} -F #{config[:wpar_name]}", :stderr)
        if wpar_exists?(state)
          raise ActionFailed, "couldn't destroy wpar !"
        end
      end

      protected
      def build_mkwpar_command()

        cmd = "#{config[:mkwpar]} -s -n #{config[:wpar_name]}"
        unless config[:wpar_address].nil?
          cmd += " -N address=#{config[:wpar_address]}"
        end

        unless config[:wpar_vg].nil?
          cmd += " -g #{config[:wpar_vg]}"
        end

        unless config[:wpar_rootvg].nil?
          cmd += " -D rootvg=yes devname=#{config[:wpar_rootvg]}"
        end

        unless config[:wpar_mksysb].nil?
          cmd += " -C -B #{config[:wpar_mksysb]}"
        end

        if config[:isWritable]
          cmd += ' -l'
        end


        cmd
      end

      def copy_key()
        cmd = "mkdir /wpars/#{config[:wpar_name]}/.ssh;"
        cmd += "chmod 700 /wpars/#{config[:wpar_name]}/.ssh"
        ssh_command(cmd, :stderr)
        cmd="cp ~/.ssh/authorized_keys /wpars/#{config[:wpar_name]}/.ssh"
        ssh_command(cmd, :stderr)
      end

      def wpar_exists?(state)
        output=ssh_command("#{config[:lswpar]} #{config[:wpar_name]}", :stderr)
        if output.include?('0960-419')
          return false
        end
        true
      end

      def ssh_command(cmd, stream)
        out = ''
        begin
          host = config[:aix_host]
          user = config[:aix_user]
          keys = config[:aix_key]
          Net::SSH.start(host, user, :keys => keys) do |ssh|
            ssh.exec!(cmd) do |channel, stream, data|
              out << data if stream == stream
              print data
            end
            out
          end
        rescue
          raise ActionFailed, 'ssh command failed !'
        end
      end

    end
  end
end
