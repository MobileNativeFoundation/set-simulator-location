# set-simulator-location

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

## Installation

With [`homebrew`](http://brew.sh/):

```sh
$ brew install lyft/formulae/set-simulator-location
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
