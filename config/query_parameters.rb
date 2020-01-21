module PeoplesoftCourseClassData
  module Config
    CAMPUSES = [
                {
                  institution: "UMNDL",
                  campus: "UMNDL"
                },
                {
                  institution: "UMNMO",
                  campus: "UMNMO"
                },
                {
                  institution: "UMNCR",
                  campus: "UMNCR"
                },
                {
                  institution: "UMNTC",
                  campus: "UMNTC"
                },
                {
                  institution: "UMNTC",
                  campus: "UMNRO"
                }
              ]
    TERMS = [
      {term: '1203'},
      {term: '1205'},
      {term: '1209'},
      {term: '1213'},
    ]

    QUERY_PARAMETERS = CAMPUSES.inject([]) do |array, campus|
                          array << TERMS.map { |term| campus.merge(term) }
                       end.flatten

  end
end
