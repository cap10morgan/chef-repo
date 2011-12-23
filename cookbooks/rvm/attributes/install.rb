# Set this to the full ruby version string (or a unique prefix thereof)
# of the Ruby installation that you want to be the default. A value of
# 'system' won't set a default.
#
# Examples:
# REE 1.8.7      - 'ree-1.8.7'
# MRI 1.9.2-p290 - 'ruby-1.9.2-p290'
# Any MRI 1.9.2  - 'ruby-1.9.2'
# JRuby          - 'jruby'

default[:rvm][:ruby][:default] = 'system'
