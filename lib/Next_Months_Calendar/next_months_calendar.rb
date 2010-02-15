class Next_Months_Calendar

  def run(params)
    today = Date.today
    nextmonth = today >> 1
    system("cal","#{nextmonth.month}","#{nextmonth.year}")
  end

end
