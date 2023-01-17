# set-simulator-location

NOTE: As of Xcode 14 you can use `xcrun simctl location` to do most of
this instead, including setting specific routes. Use that if possible
(it does not currently support searching for locations).

This is a simple CLI for easily setting the location of the currently
running iOS Simulator.

## Usage

Set a specific latitude and longitude:

```sh
$ set-simulator-location -c 37.7765 -122.3918
```

Or using place search:

```sh
$ set-simulator-location -q Lyft HQ San Francisco
```

By default the location is set on all booted simulators. If you'd like
to change it for only one of the booted simulators you can pass `-s`
followed by the simulator's display name:

```sh
$ set-simulator-location -q Lyft HQ San Francisco -s iPhone X
```

NOTE: If you have multiple booted simulators with the same name, the
location will be set on all of them.

## Installation

With [`homebrew`](http://brew.sh/):

```sh
$ brew install lyft/formulae/set-simulator-location
```

With [`Mint`](https://github.com/yonaskolb/Mint):

```sh
$ mint install lyft/set-simulator-location
```

With a precompiled release:

1. Download the latest release from
   [here](https://github.com/lyft/set-simulator-location/releases/)
1. Install it some place in your `$PATH`

Manually:

```sh
$ make install
```

I have submitted [a Radar](http://www.openradar.me/30789939) to have
this behavior added to `simctl`.

### Development

To work on `set-simulator-location` you can make your changes and run
`make` to build from the command line. If you'd prefer to work in Xcode
you can run `make xcode` to generate a project using SwiftPM.
