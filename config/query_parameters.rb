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
      {term: '1215'},
      {term: '1219'},
      {term: '1223'},
    ]

    QUERY_PARAMETERS = CAMPUSES.inject([]) do |array, campus|
                          array << TERMS.map { |term| campus.merge(term) }
                       end.flatten

  end
end
