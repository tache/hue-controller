hue-controller
====

Description
-----------
Control your Hue lights via Ruby.

Installation
------------

Install directly or with RVM. This example used the latest stable release from [Ruby Lang](https://www.ruby-lang.org/en/downloads) at the time.

```bash
ruby -v
```

```
ruby 2.7.4p191 (2021-07-07 revision a21a3b7d23) [x86_64-darwin20]
```

Then within your directory, setup via [RVM] (https://rvm.io) commands:

```bash
rvm --rvmrc --create ruby-2.7.4@huelights
rvm --rvmrc use ruby-2.7.4@huelights
rvm rvmrc to ruby-version
```

Install the `bundler` gem

```bash
bundle -v
```
```
Bundler version 2.2.29
```

Install the version that matches the Gemfile

```bash
gem install bundler:2.1.4
```

You will see a file in the root project directory called Gemfile. That contains the version of the gems used in the project.

```bash
bundle install
```

Usage
------------

After setup, edit the file to add the ip of your Hue hub and developer ID. To get your developer ID, see the instructions on [Hue Getting Started](https://developers.meethue.com/develop/get-started-2/)

When all setup, you can see what commands are available:

```bash
./huecontroller.thor
```
```
Commands:
  huecontroller.thor animate IDs     # Animate specified lights
  huecontroller.thor config          # Find out detail on your hue configuration items
  huecontroller.thor crackle ID      # Performs a crackling effect on a light
  huecontroller.thor discover        # Discover the lights and respective ids.
  huecontroller.thor groups          # Find out detail on your hue groups
  huecontroller.thor help [COMMAND]  # Describe available commands or one specific command
  huecontroller.thor light ID        # Find out detail on a single light
  huecontroller.thor lights          # Find out detail on your entire hue light configuration
  huecontroller.thor reboot          # Find out detail on your hue configuration items
  huecontroller.thor state ID        # Find a light's on/off and color state
  huecontroller.thor times           # Find out sunrise and sunset times
```

Discover your light IDs:

```
./huecontroller.thor discover
```

```
Hue Light Discovery!
1 - Media Lamp 1 - false
2 - Media Lamp 2 - false
3 - Media Lamp 3 - false
21 - Office 1 - true
22 - Office 2 - true
25 - Office 3 - true
26 - Office 4 - true
27 - Office 5 - true
32 - Holiday 1 - true
```

Query the state of a single light:

```
./huecontroller.thor state 21
```

```
Getting Light state for 21!
Light Detail: state: true - bri: 200 - sat: 189 - hue: 13878 - xy: [0.4922, 0.4151]
```

Animate the lights with color. You can configure the lights in the script:

```
./huecontroller.thor animate 21
```

```
Animating Light: Office 5 state: [true]
Target Light: 21 - [0.1821, 0.0698] - [0.1821, 0.0698]
Target Light: 21 - [0.6455, 0.3428] - [0.6455, 0.3428]
```

License
-------
Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE.md
