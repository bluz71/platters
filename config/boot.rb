ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap'
Bootsnap.setup(
  cache_dir:  'tmp/cache',
  development_mode: ENV['RAILS_ENV'] == 'development',
  load_path_cache: true,
  autoload_paths_cache: true,
  disable_trace: false,
  compile_cache_iseq: true,
  compile_cache_yaml: true
)
