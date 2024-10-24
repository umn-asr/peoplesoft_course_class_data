module Days
  class AbstractDay
    def type
      "day"
    end

    def ==(other)
      return false unless self.class == other.class

      name == other.name
    end
    alias_method :eql?, :==

    def hash
      name.hash
    end

    def json_tree
      {
        type: type,
        name: name,
        abbreviation: abbreviation
      }
    end

    def merge(other)
      # noop
    end
  end

  class Monday < AbstractDay
    def xml_tag
      "A.MON"
    end

    def name
      "monday"
    end

    def abbreviation
      "m"
    end
  end

  class Tuesday < AbstractDay
    def xml_tag
      "A.TUES"
    end

    def name
      "tuesday"
    end

    def abbreviation
      "t"
    end
  end

  class Wednesday < AbstractDay
    def xml_tag
      "A.WED"
    end

    def name
      "wednesday"
    end

    def abbreviation
      "w"
    end
  end

  class Thursday < AbstractDay
    def xml_tag
      "A.UM_THURS"
    end

    def name
      "thursday"
    end

    def abbreviation
      "th"
    end
  end

  class Friday < AbstractDay
    def xml_tag
      "A.FRI"
    end

    def name
      "friday"
    end

    def abbreviation
      "f"
    end
  end

  class Saturday < AbstractDay
    def xml_tag
      "A.SAT"
    end

    def name
      "saturday"
    end

    def abbreviation
      "sa"
    end
  end

  class Sunday < AbstractDay
    def xml_tag
      "A.UM_SUNDAY"
    end

    def name
      "sunday"
    end

    def abbreviation
      "su"
    end
  end

  ALL_DAYS = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]

  def self.for_xml_tag(xml_tag)
    ALL_DAYS.map(&:new).detect { |day| day.xml_tag == xml_tag }
  end
end
