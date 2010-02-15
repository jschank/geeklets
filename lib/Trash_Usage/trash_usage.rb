class Trash_Usage

  def run(params)
    system("du -sh ~/.Trash/ | awk '{print \"Trash is using \"$1}'")    
  end

end

