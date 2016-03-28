module PeoplesoftCourseClassData
  module Config
    CAMPUSES = [
                # {
                #   institution: "UMNDL",
                #   campus: "UMNDL"
                # },
                {
                  institution: "UMNMO",
                  campus: "UMNMO"
                },
                # {
                #   institution: "UMNCR",
                #   campus: "UMNCR"
                # },
                # {
                #   institution: "UMNTC",
                #   campus: "UMNTC"
                # },
                # {
                #   institution: "UMNTC",
                #   campus: "UMNRO"
                # }
                {
                  institution: "UMNTC",
                  campus: "UMNTC"
                }
              ]
    TERMS = [
      # {term: '1163'},
      # {term: '1165'},
      # {term: '1169'}
      {term: '1165'}
    ]

    QUERY_PARAMETERS = CAMPUSES.inject([]) do |array, campus|
                          array << TERMS.map { |term| campus.merge(term) }
                       end.flatten

  end
end
