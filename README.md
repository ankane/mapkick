# Mapkick

Create beautiful JavaScript maps with one line of Ruby. No more fighting with mapping libraries!

[See it in action](https://chartkick.com/mapkick)

:fire: For static maps, check out [Mapkick Static](https://github.com/ankane/mapkick-static), and for charts, check out [Chartkick](https://chartkick.com)

[![Build Status](https://github.com/ankane/mapkick/workflows/build/badge.svg?branch=master)](https://github.com/ankane/mapkick/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "mapkick-rb"
```

Mapkick uses [Mapbox GL JS v1](https://github.com/mapbox/mapbox-gl-js/tree/v1.13.3). To use tiles from Mapbox, [create a Mapbox account](https://account.mapbox.com/auth/signup/) to get an access token and set `ENV["MAPBOX_ACCESS_TOKEN"]` in your environment (or set `Mapkick.options[:access_token]` in an initializer).

Then follow the instructions for your JavaScript setup:

- [Importmap](#importmap) (Rails 7 default)
- [esbuild, rollup.js, or Webpack](#esbuild-rollup-js-or-webpack)
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

Point map

```erb
<%= js_map [{latitude: 37.7829, longitude: -122.4190}] %>
```

Area map

```erb
<%= area_map [{geometry: {type: "Polygon", coordinates: ...}}] %>
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

### Point Map

Use `latitude` or `lat` for latitude and `longitude`, `lon`, or `lng` for longitude

You can specify a label, tooltip, and color for each data point

```ruby
{
  latitude: ...,
  longitude: ...,
  label: "Hot Chicken Takeover",
  tooltip: "5 stars",
  color: "#f84d4d"
}
```

### Area Map

Use `geometry` with a GeoJSON `Polygon` or `MultiPolygon`

You can specify a label, tooltip, and color for each data point

```ruby
{
  geometry: {type: "Polygon", coordinates: ...},
  label: "Hot Chicken Takeover",
  tooltip: "5 stars",
  color: "#0090ff"
}
```

## Options

Id, width, and height

```erb
<%= js_map data, id: "cities-map", width: "800px", height: "500px" %>
```

Marker color

```erb
<%= js_map data, markers: {color: "#f84d4d"} %>
```

Show tooltips on click instead of hover

```erb
<%= js_map data, tooltips: {hover: false} %>
```

Allow HTML in tooltips (must sanitize manually)

```erb
<%= js_map data, tooltips: {html: true} %>
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

Pass options directly to the mapping library

```erb
<%= js_map data, library: {hash: true} %>
```

See the documentation for [Mapbox GL JS](https://docs.mapbox.com/mapbox-gl-js/api/map/) for more info

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
