#TODO: find a way to compare 2 pdf files..  maybe with git

def check_diff (pdf1, pdf2)
  fname = "compare.txt"

  system("diff \"#{pdf1}\" \"#{pdf2}\" > compare.txt")

  if File.file?(fname)
    is_diff = !File.zero?(fname)
    File.delete(fname)
  else
    Utils.die("error with pdf diff")
  end
  is_diff
end
