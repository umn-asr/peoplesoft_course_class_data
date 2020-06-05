module PeoplesoftCourseClassData
  module Config
    CAMPUSES = [
                {
                  institution: "UMNTC",
                  campus: "UMNTC"
                }
              ]
    TERMS = [
      {term: '1205'}
    ]

    QUERY_PARAMETERS = CAMPUSES.inject([]) do |array, campus|
                          array << TERMS.map { |term| campus.merge(term) }
                       end.flatten

  end
end
