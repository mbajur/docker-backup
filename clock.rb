require 'clockwork'
require 'open3'

include Clockwork

logger = Logger.new(STDOUT)
cmd    = 'backup perform --trigger backup'

timing    = ENV['FREQUENCY'].present? ? eval(ENV['FREQUENCY']) : 1.day
timing_at = ENV['FREQUENCY_AT']

logger.debug 'Clockwork settings:'
logger.debug "Frequency: #{timing}"
logger.debug "Frequency (at): #{timing_at}"

handler do |job|
  Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
    while line = stdout.gets
      puts line
    end
  end

  logger.info 'Backup finished.'
end

opts = {}
opts.merge!(at: timing_at) if timing_at

every(timing, 'do_backup', opts)
