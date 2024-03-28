# KinoLiveReload

[![KinoLiveReload version](https://img.shields.io/hexpm/v/kino_livereload.svg)](https://hex.pm/packages/kino_livereload)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/kino_livereload/)
[![Hex Downloads](https://img.shields.io/hexpm/dt/kino_livereload)](https://hex.pm/packages/kino_livereload)
[![GitHub stars](https://img.shields.io/github/stars/thmsmlr/kino_livereload.svg)](https://github.com/thmsmlr/kino_livereload/stargazers)
[![Twitter Follow](https://img.shields.io/twitter/follow/thmsmlr?style=social)](https://twitter.com/thmsmlr)

<!-- Docs -->

kino_livereload brings the developer experience of a Phoenix application to Livebook.

Simply mark which cell you want to livereload with `use KinoLiveReload, watch: MyModule` to 
rerun the cell anytime the source code for MyModule changes. You can provide a single module or a 
list of modules to the `watch:` paramater.

For example,

```elixir
use KinoLiveReload, watch: MyLocalModule

MyLocalModule.hello()

# => "world"

# Edit to /path/to/my-local-module.ex

# => "thomas!"
```

Any time you make changes to the source code of MyLocalModule the cell with the aforementioned code will automatically recompile, and rerun.

<!-- Docs -->

## Motivation

Livebook is a godsend for productivity.
When you are working on code that requires a long boot up time, whether it be waiting for resources, or doing some long computation, Livebook lets you implicitly cache previous results.
It's like a repl, but more permanent as you can rerun cells, save notbooks and rerun them later.
However, ultimately we know that our code ultimately ends in a Mix projects.
That's where a gap still existis. 
While Livebook is better than IEX, there is still a jump between Livebook and a Mix project. 
That's why I built `:kino_livereload`.
Let me explain.

Frequently you'll start writing an adhoc script in Livebook because you get a REPL like experience with visual, rerunnable feedback.
However, at some point your Livebooks in a project become too large and you want to refactor helper functions into a library.
This is where the first problem begins.
Since installing dependencies happens in the first cell as part of the `Mix.install(...)` if you need to fix and edge case in a refactored helper function, you have to rerun the entire notebook, nullifying the benefits of the REPL.
At which point you are no better off than moving the Livebook into a test and running `mix test`.

Now that's just in the refactoring usecases. Imagine you wanted to co-develop a library with a livebook. 
At least when you're fixing edge cases in a refactor, maybe the hit to developer productivity is tolerable to continue using Livebook (but then again why?).
Whereas in a co-develop situation as you'd constantly be rerunning the entire Livebook.

That's where `:kino_livereload` comes in. 
This library brings Phoenix LiveReload functionality to Livebook.
When you have a local library that you're actively working on, upon which a specific Livebook cell depends, you can mark the cell and just rerun that cell anytime the underlying source code changes.

This is particularly useful if you have a usecase where you are actively iterating on helper functions that operate on some expensive data to initial load/compute.
For example, in my usecase, I built this because I was working on a webscraper.
I had many functions which I was iterating that on extracting data from the HTML.
The Livebook would initialize the browser, set the cookies, and do the actions that would get the browser into the appropriate state before I could test my extract.
This could take up to 5-10 seconds, just to test a CSS Selector change.

With this library, I was able to keep the Browser state cached within the Livebook and just recompile/reload the extraction code as I was updating it in the shared library.

This lead to a much smoother path between prototype and production.
I was able to continue to leverage the visual / repl nature of Livebook, while still working on my code in it's final location.

## Installation

In your Livebook,

```elixir
Mix.install([
  {:kino_livereload, "~> 0.1.0"}
])
```


