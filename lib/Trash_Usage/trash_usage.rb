class Trash_Usage < Geeklet

  def run(params)
    super(:Trash_Usage, params)
    Kernel.system("du -sh ~/.Trash/ | awk '{print \"Trash is using \"$1}'")    
  end

end

