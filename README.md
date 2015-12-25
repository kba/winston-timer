winston-timer
-----------------
Extend winston to measure time intervals

## Description

An important use of logging is to measure performance of certain parts of the
codebase. To make this easier, this module extends the
[winston](http://npmjs.org/package/winston) logging framework for NodeJS with
named timers that are started and return the [high-resolution time
difference](https://nodejs.org/api/process.html#process_process_hrtime)  when
they were stopped.


## Installation

```
npm install --save winston-timer
```

## Usage

The module exports a single function that expects a winston logger instance and
an optional [configuration](#configuration) object.

In the simplest case (using `winston` as a global logger):

```js
var winston = require('winston');
require('winston-timer')(winston);
```

You can also pass a stand-alone `Winston.Logger` object:

```js
var winston = require('winston');
var log = new Winston.Logger(/* ... */);
require('winston-timer')(logger, {
    "useColors": false
});
```

Then you can use the [methods provided by the API](#api) to start and stop
timers and log their results:

```js
winston.start_log('long-running-task', 'info'); 
/* ... */
winston.stop_log('long-running-task', 'warn');
```

Output:

```
info: Starting timer 'long-running-task'
debug Finished timer 'long-running-task' in 1007.194189 ms
```

See [test/example.js](./test/example.js) for a short example script.

## API

Time difference is measured in a
[second-nanosecond-tuple](https://nodejs.org/api/process.html#process_process_hrtime).

To get the time difference in milliseconds, use the [`stop_ms`](#stop_ms)
method or log in milliseconds directly using [`stop_log`](#stop_log) method.

starting a timer that has already been started or stopping a timer that has
already been stopped will cause an exception.

### start(timer)

```js
start(timer)
```
Starts a timer.

Arguments:
* timer [String] **Required**: Name of the task to time. 

Returns:
* The s-ns-tuple this timer was started

### stop

```js
stop(timer)
```
Stops a timer.

Arguments:
* timer [String] **Required**: Name of the task to time. 

Returns:
* The s-ns-tuple this timer was stopped.

### stop_ms

```js
stop_ms(timer)
```
Stops a timer and returns the time passed in milliseconds.

Arguments:
* timer [String] **Required**: Name of the task to time. 

Returns:
* The time passed in milliseconds.

### start_log

```js
start_log(timer, level, prefix, suffix)
```
Starts a timer and logs a message with the timer name. By default it looks like
this:
```
debug: Starting timer "<name of the timer>"
```
Arguments:
* timer [String] **Required**: Name of the task to time.
* level [String] *Optional*: The log level to use. One of `silly`, `debug`, `info`,
  `warn`, `error`. Default: [`config.level`](#level).
* prefix [String] *Optional*: String to print before the timer name. Default: [`config.start_prefix`](#start_prefix).
* suffix [String] *Optional*: String to print after the timer name. Default: [`config.start_suffix`](#start_suffix).

### stop_log

```js
stop_log(timer, level, prefix, suffix)
```

Stops a timer and logs a message with the timer name and the time elapsed in
milliseconds. By default, it looks like this:

```
debug: Finished timer "<name of the timer>" in 1007.449218 ms
```

As an additional convenience, the elapsed time is highlighted according to how
long it took. This behavior can be disabled by setting
[`config.use_colors`](#use_colors) to `false` and the threshold times to change
colors and the colors to use can be changed with the
[`config.thresholds`](#thresholds) and [`config.colors`](#colors) arrays.

By default times will be highlighted
* < 10 ms: `bold green`
* < 100 ms: `green`
* < 500 ms: `yellow`
* < 1000 ms: `red`
* > 1000 ms: `bold red`

Arguments:
* timer [String] **Required**: Name of the task to time.
* level [String] *Optional*: The log level to use. One of `silly`, `debug`, `info`,
  `warn`, `error`. Default: [`config.level`](#level).
* prefix [String] *Optional*: String to print before the timer name. Default: [`config.stop_prefix`](#stop_prefix).
* suffix [String] *Optional*: String to print after the timer name. Default: [`config.stop_suffix`](#stop_suffix).

## Configuration

The configuration object can be passed as the second argument to the exported
method to change the defaults, e.g.
```js
require('winston-timer')(logger, {
    "level": "info",
    "use_colors": false
});
```

### level

Logging level to use for [`start_log`](#start_log) and [`stop_log`](#stop_log).

Default: `debug`

### use_colors

Whether to use colors for highlighting the elapsed time.

Default: `true`

### thresholds

Thresholds at which to change the color highlighting of the elapsed time.

Default: `[10, 100, 500, 999, Number.MAX_VALUE]`

### colors

Colors used for highlighting elapsed times.

See the [chalk](http://npmjs.com/package/chalk) module for possible values.

Default: `[chalk.green.bold, chalk.green, chalk.yellow, chalk.red, chalk.red.bold]`

### start_prefix

Text before the timer name.

Default: `'Starting timer "'`

### start_suffix

Text after the timer name.

Default: `'"'`

### stop_prefix

Text before the timer name.

Default: `'Finished timer "'`

### stop_suffix

Text after the timer name.

Default: `'" in '`
