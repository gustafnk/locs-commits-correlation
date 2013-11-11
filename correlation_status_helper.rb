def get_correlation_status(r_squared)

  rounded = r_squared.round(1)

  if rounded >= 0.7
    "Correlation";
  elsif 0.5 <= rounded && rounded < 0.7
    "Correlation-ish"
  else 
    "No correlation"
  end
end


