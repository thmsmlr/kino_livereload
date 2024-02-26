# KinoLiveReload

[![KinoLiveReload version](https://img.shields.io/hexpm/v/kino_livereload.svg)](https://hex.pm/packages/kino_livereload)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/kino_livereload/)
[![Hex Downloads](https://img.shields.io/hexpm/dt/kino_livereload)](https://hex.pm/packages/kino_livereload)
[![GitHub stars](https://img.shields.io/github/stars/thmsmlr/kino_livereload.svg)](https://github.com/thmsmlr/kino_livereload/stargazers)
[![Twitter Follow](https://img.shields.io/twitter/follow/thmsmlr?style=social)](https://twitter.com/thmsmlr)

<!-- Docs -->

kino_livereload brings the developer experience of a pheonix application to Livebook.

Simply mark which cell you want to livereload with `use KinoLiveReload, watch: MyModule` to 
rerun the cell anytime the source code for MyModule changes. You can provide a single module or a 
list of modules to the `watch:` paramater.

For example,

```elixir
use KinoLiveReload, watch: MyLocalModule

MyLocalModule.hello()

# => "world"
```

Any time you make changes to the source code of MyLocalModule the cell with the aforementioned code will automatically recompile, and rerun.

<!-- Docs -->

## Installation

In your Livebook,

```elixir
Mix.install([
  {:kino_livereload, "~> 0.0.1"}
])
```


