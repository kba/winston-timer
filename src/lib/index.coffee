'use strict'
Chalk = require 'chalk'

MILLION = 1000000
BILLION = 1000000000

DEFAULT_CONFIG =
	level: 'debug'
	use_colors: true
	thresholds: [10, 100, 500, 999, Number.MAX_VALUE]
	colors: [Chalk.green.bold, Chalk.green, Chalk.yellow, Chalk.red, Chalk.red.bold]
	start_prefix: 'Starting timer "'
	stop_prefix: 'Finished timer "'
	start_suffix: '"'
	stop_suffix: '" in'

module.exports = (logger, configIn) ->
 config = {}
 if configIn?
   for own key, value of DEFAULT_CONFIG
     if configIn[key]?
       config[key] = configIn[key]
     else
       config[key] = DEFAULT_CONFIG[key]
 else
   config = DEFAULT_CONFIG
   
 logger._profiling_timers = {}
  
	logger.start = (name) ->
		if logger._profiling_timers[name]
			throw new Error('Timer already started: \'' + name + '\'')
		now =  process.hrtime()
		logger._profiling_timers[name] = now
		return now

	logger.stop = (name) ->
		if !logger._profiling_timers[name]
			throw new Error('Timer not started: \'' + name + '\'')
		diff = process.hrtime(logger._profiling_timers[name])
		delete logger._profiling_timers[name]
		return diff

	logger.stop_ms = (name) ->
		diff = logger.stop(name)
		return (diff[0] * BILLION + diff[1]) / MILLION

	logger.start_log = (name, level, prefix, suffix) ->
		level or= config.level
		prefix or= config.start_prefix
		suffix or= config.start_suffix
		logger.start(name)
		logger.log level, prefix + name + suffix

	logger.stop_log = (name, level, prefix, suffix) ->
		level or= 'debug'
		prefix or= config.stop_prefix
		suffix or= config.stop_suffix
		ms = logger.stop_ms(name)
		if config.use_colors
			for threshold,idx in config.thresholds
				if ms < threshold
					ms = config.colors[idx].apply(null, [ms])
		logger.log level, prefix + name + suffix, ms + ' ms'
		return
