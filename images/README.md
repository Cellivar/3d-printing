# Docker images for Klipper

I run Klipper using my [Nomad cluster](https://www.nomadproject.io/), which makes managing my RasPi machines much easier and consistent with the rest of the cluster. Things are generally easier when they're in containers, so that means putting klipper in a box.

[Markus has already done this work in the prind project](https://github.com/mkuf/prind/tree/main) and was the starting point for these images. The prind project is focused on docker-compose based deployments which are not compatible with how Nomad manages resources, especially network-mounted volumes. Additionally I wanted to add some shenanigans to the images.

## Differences with Prind

Most of the software I've encountered for Klipper expects to be installed to a linux user's home directory, usually `/home/username/klipper` and expects a config directory of `home/username/printer_data/config` with associated paths. Since a lot of defaults assume this pattern I found it easier to roll with the flow and build my docker images using those same paths.

The images come preconfigured to use `~/printer_data` as the expected volume to be mapped. While each image has a different user, you can mount `printer_data` to the same external volume so they can all share the same configs. This also makes it easier back up those configs.

To also support the unix sockets that klipper, host_mcu, and moonraker use to communicate I follow the prind project and use a `~/printer_data/run` directory for all unix sockets.

## Klipper

The thing that runs the actual printer!

Mount `/home/klipper/printer_data` to a shared volume with the other containers.

You will want to use `~/printer_data` for configurations, for example:

```toml
[virtual_sdcard]
  path: ~/printer_data/gcodes

[save_variables]
  filename: ~/printer_data/config/xvariables.cfg
```

### Considerations for Running

The Klipper container [needs direct access to the hardware](https://github.com/mkuf/prind/issues/77) resources it communicates with. This includes serial devices, USB devices, a canbus network, GPIO, etc. and generally requires:

1. The docker container run in `privileged` mode.
2. Mount `/dev:/dev` into the container so it can see all devices.
3. Ensure the `dialout` group has access to the `gpio` kernel interface.
4. Ensure the docker user is in the `dialout` group.
5. Use `host` network mode.

1 and 2 are straightforward. 3 can be accomplished by running this command on the host machine:

`echo 'SUBSYSTEM=="gpio", KERNEL=="gpiochip*", GROUP:="dialout", MODE:="0660"' > /etc/udev/rules.d/90-gpio.rules`

This adds a udev rule that ensure the `gpiochip` system is available to the `dialout` group with read/write access. I needed to do this on my Ubuntu image which was not custom tailored for the RasPi I'm running it on. You may not need to do this.

4 can be accomplished with the `docker --group_add dialout` flag and the `group_add:` docker-compose option. For Nomad I add the `group_add = ["dialout"]` to the docker config in my task definition.

5 is required if you use a `canbus` device on your host machine. Docker doesn't.. _understand_ canbus networks, really, and anything other than `host` networking mode will make it fail to communicate.

## HostMcu

Slim image for `[hostmcu]` use on a raspi board.

Mount `/opt/printer_data` to a shared volume.

Add the additional mcu block using the `printer_data/run` directory:

```toml
[mcu host]
  serial: ~/printer_data/run/klipper_host_mcu.tty
```

## Moonraker

Control API server for Klipper.

Mount `/home/moonraker/printer_data` to a shared volume.

On the RasPi the Moonraker image can control GPIO pins for things like powering off a relay. Depending on your distro you'll need to mount those devices in. On my Raspi4 running Ubuntu that was these three devices, along with adding the user to the `dialout` group.

* `/dev/gpiochip0`
* `/dev/gpiochip1`
* `/dev/gpiomem`
