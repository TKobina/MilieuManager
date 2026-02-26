class MilieuChronoprocJob < ApplicationJob
  queue_as :high

  def perform(*milieu, ydate)
    milieu.first.proc_chronology(ydate: ydate)
  end
end
