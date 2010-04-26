class Next_Months_Calendar < Geeklet

  def run(params)
    super
    today = Date.today
    nextmonth = today >> 1
    Kernel.system("cal","#{nextmonth.month}","#{nextmonth.year}")
  end

end
