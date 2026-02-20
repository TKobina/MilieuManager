class MilieuChronoprocJob < ApplicationJob
  queue_as :high

  def perform(*milieu)
    milieu.first.proc_chronology
  end
end
