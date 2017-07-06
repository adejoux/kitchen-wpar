# <a name="title"></a> Kitchen::Wpar

A Test Kitchen Driver for Wpar.

## <a name="requirements"></a> Requirements

You need a AIX partition with chef client and sudo installed.

## <a name="installation"></a> Installation and Setup

Please read the [Driver usage][driver_usage] page for more details.

## <a name="config"></a> Configuration

**TODO:** Write descriptions of all configuration options
* **wpar_name**     wpar name on AIX global system. Default to **kitchenwpar**.
* **aix_host**	    aix global partition name. Default to **localhost**.
* **aix_user**	    aix global partition username. Default to **root**.
* **aix_key**	      Specify a path to the ssh key to create a connection.
* **wpar_address**	wpar IP address to use. Not needed if an entry already exists in `/etc/hosts` on Global partition.
* **wpar_vg**	      Volume group to use to store shared wpar filesystems. Default to **rootvg**.
* **wpar_rootvg**	  Specify the `hdisk` to use to create a rootvg system wpar.
* **wpar_mksysb**	  uses a wpar backup. Specify a path to a backup to save time.
* **wpar_copy_rootvg**	  adds the option ' -t' to copy rootvg file systems.
* **isVersioned**         create a versioned wpar. Used only with **wpar_mksysb**.
* **isWritable**	  adds the option ' -l' to have a non-shared, writable /usr file system and /opt file system. 
* **share_network_resolution**	  adds the option ' -r' to share name resolution services (i.e. `/etc/resolv.conf`) with the wpar.


### <a name="config-require-chef-omnibus"></a> require\_chef\_omnibus

Determines whether or not a Chef [Omnibus package][chef_omnibus_dl] will be
installed. There are several different behaviors available:

* `true` - the latest release will be installed. Subsequent converges
  will skip re-installing if chef is present.
* `latest` - the latest release will be installed. Subsequent converges
  will always re-install even if chef is present.
* `<VERSION_STRING>` (ex: `10.24.0`) - the desired version string will
  be passed the the install.sh script. Subsequent converges will skip if
  the installed version and the desired version match.
* `false` or `nil` - no chef is installed.

The default value is unset, or `nil`.
Should be `false` if your AIX system has no internet access.

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## <a name="authors"></a> Authors

Created and maintained by [Alain Dejoux][author] (<adejoux@djouxtech.net>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/adejoux
[issues]:           https://github.com/adejoux/kitchen-wpar/issues
[license]:          https://github.com/adejoux/kitchen-wpar/blob/master/LICENSE
[repo]:             https://github.com/adejoux/kitchen-wpar
[driver_usage]:     https://docs.chef.io/kitchen.html#drivers
[chef_omnibus_dl]:  http://www.chef.io/chef/install/
