FUNCTION s2hms, seconds

   hr= long(seconds)/3600
   mn= long(seconds-hr*3600)/60
   s = (seconds - (hr*3600L + mn*60))

RETURN, [hr,mn,s]
END
