# encoding: utf-8

require 'uri'

DATABASE_URL = URI.parse ENV['DATABASE_URL']

##
# Backup Generated: my_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:backup, ENV['DESCRIPTION']) do
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #
  # archive :my_archive do |archive|
  #   # Run the `tar` command using `sudo`
  #   # archive.use_sudo
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/folder/"
  #   archive.exclude "/path/to/a/excluded_file.rb"
  #   archive.exclude "/path/to/a/excluded_folder"
  # end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = ENV['STORAGE_LOCAL_PATH'] || "~/backups/"
    local.keep       = ENV['STORAGE_LOCAL_KEEP'] || 5
    # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = DATABASE_URL.path.delete('/')
    db.username           = DATABASE_URL.user
    db.password           = DATABASE_URL.password
    db.host               = DATABASE_URL.host
    db.port               = DATABASE_URL.port || 5432
    # db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ['skip', 'these', 'tables']
    # db.only_tables        = ['only', 'these' 'tables']
    # db.additional_options = []
  end if DATABASE_URL.scheme == 'postgres'

  ##
  # Slack [Notifier]
  #
  if ENV['NOTIFIER_SLACK']
    notify_by Slack do |slack|
      slack.on_success = ENV['NOTIFIER_SLACK_ON_SUCCESS'] == 'true'
      slack.on_warning = ENV['NOTIFIER_SLACK_ON_WARNING'] == 'true'
      slack.on_failure = ENV['NOTIFIER_SLACK_ON_FAILURE'] == 'true'

      # The incoming webhook url
      # https://hooks.slack.com/services/xxxxxxxx/xxxxxxxxx/xxxxxxxxxx
      slack.webhook_url = ENV['NOTIFIER_SLACK_WEBHOOK_URL']

      ##
      # Optional
      #
      # The channel to which messages will be sent
      # slack.channel = 'my_channel'
      #
      # The username to display along with the notification
      # slack.username = 'my_username'
    end
  end

end
