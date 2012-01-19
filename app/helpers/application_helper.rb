module ApplicationHelper
  TYPE_MAP = [
    ["Girls who like guys:", "34"],
    ["Guys who like girls:", "17"],
    ["Girls who like girls:", "40"],
    ["Guys who like guys:", "20"],
    ["Both who like bi guys:", "54"],
    ["Both who like bi girls:", "57"],
    ["Straight girls only:", "2"],
    ["Straight guys only:", "1"],
    ["Gay girls only:", "8"],
    ["Gay guys only:", "4"],
    ["Bi Girls only:", "32"],
    ["Bi Guys only:", "16"],
    ["Everybody:", "63"],
  ]
  ETHNICITY_MAP = [
    ["Asian", "asian"],
    ["Middle Eastern", "middle_eastern"],
    ["Black", "black"],
    ["Native American", "native_american"],
    ["Indian", "indian"],
    ["Pacific Islander", "pacific_islander"],
    ["Latin", "latin"],
    ["White", "white"],
    ["Human", "human"]
  ]
  HAS_PHOTO_MAP = [
    ["Yes", "1"],
    ["No", "0"]
  ]
  LAST_ONLINE_MAP = [
    ["Online now", "3600"],
    ["In the last day", "86400"],
    ["In the last week", "604800"],
    ["In the last month", "2678400"],
    ["In the last year", "31536000 "]
  ]
  STATUS_MAP = [
    ["Single", "2"],
    ["Not single", "12"],
    ["Any status", "0"]
  ]
  RADIUS_MAP = [
    ["5 miles", "5"],
    ["25 miles", "25"],
    ["50 miles", "50"],
    ["100 miles", "100"],
    ["250 miles", "250"],
    ["500 miles", "500"]
  ]
end
