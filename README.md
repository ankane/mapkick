# Mapkick

Create beautiful JavaScript maps with one line of Ruby. No more fighting with mapping libraries!

[See it in action](https://chartkick.com/mapkick)

:fire: For charts, check out [Chartkick](https://chartkick.com)

[![Build Status](https://github.com/ankane/mapkick/workflows/build/badge.svg?branch=master)](https://github.com/ankane/mapkick/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "mapkick-rb"
```

Mapkick uses [Mapbox GL JS v1](https://github.com/mapbox/mapbox-gl-js/tree/v1.13.3). To use tiles from Mapbox, [create a Mapbox account](https://account.mapbox.com/auth/signup/) to get an access token and set `ENV["MAPBOX_ACCESS_TOKEN"]` in your environment.

Then follow the instructions for your JavaScript setup:

- [Importmap](#importmap) (Rails 7 default)
- [esbuild, rollup.js, or Webpack](#esbuild-rollupjs-or-webpack)
- [Webpacker](#webpacker) (Rails 6 default)
- [Sprockets](#sprockets)

### Importmap

In `config/importmap.rb`, add:

```ruby
pin "mapkick/bundle", to: "mapkick.bundle.js"
```

And in `app/javascript/application.js`, add:

```js
import "mapkick/bundle"
```

### esbuild, rollup.js, or Webpack

Run:

```sh
yarn add mapkick
```

And in `app/javascript/application.js`, add:

```js
import "mapkick/bundle"
```

Note: For rollup.js, this requires `format: "iife"` in `rollup.config.js`.

### Webpacker

Run:

```sh
yarn add mapkick
```

And in `app/javascript/packs/application.js`, add:

```js
import "mapkick/bundle"
```

### Sprockets

In `app/assets/javascripts/application.js`, add:

```js
//= require mapkick.bundle
```

## Maps

Create a map

```erb
<%= js_map [{latitude: 37.7829, longitude: -122.4190}] %>
```

## Data

Data can be an array

```erb
<%= js_map [{latitude: 37.7829, longitude: -122.4190}] %>
```

Or a URL that returns JSON (same format as above)

```erb
<%= js_map cities_path %>
```

You can use `latitude`, `lat`, `longitude`, `lon`, and `lng`

You can specify a label and tooltip for each data point

```javascript
{
  latitude: ...,
  longitude: ...,
  label: "Hot Chicken Takeover",
  tooltip: "5 stars"
}
```

## Options

Id, width, and height

```erb
<%= js_map data, id: "cities-map", width: "800px", height: "500px" %>
```

Markers

```erb
<%= js_map data, markers: {color: "#f84d4d"} %>
```

Tooltips

```erb
<%= js_map data, tooltips: {hover: false, html: true} %>
```

Map style

```erb
<%= js_map data, style: "mapbox://styles/mapbox/outdoors-v12" %>
```

Zoom and controls

```erb
<%= js_map data, zoom: 15, controls: true %>
```

Refresh data from a remote source every `n` seconds

```erb
<%= js_map url, refresh: 60 %>
```

### Global Options

To set options for all of your maps, create an initializer `config/initializers/mapkick.rb` with:

```ruby
Mapkick.options[:height] = "400px"
```

## Sinatra and Padrino

Download [mapkick.bundle.js](https://raw.githubusercontent.com/ankane/mapkick/master/vendor/assets/javascripts/mapkick.bundle.js) and include it manually.

```html
<script src="mapkick.bundle.js"></script>
```

## No Ruby? No Problem

Check out [mapkick.js](https://github.com/ankane/mapkick.js)

## History

View the [changelog](CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/mapkick/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/mapkick/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/mapkick.git
cd mapkick
bundle install
bundle exec rake test
```
