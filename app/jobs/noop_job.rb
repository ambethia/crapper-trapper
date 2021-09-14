class NoopJob < ActiveJob::Base
  def perform(*_args)
    Rails.logger.info 'NOOP'
  end
end
