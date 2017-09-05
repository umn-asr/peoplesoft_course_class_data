require "yaml"

module PeoplesoftCourseClassData
  module Config
    credentials = YAML.load_file("config/credentials.yml")

    CREDENTIALS = {
      dev: {
        endpoint: "https://cs.dev.psoft.umn.edu/PSIGW/PeopleSoftServiceListeningConnector",
        username: credentials["dev"]["username"],
        password: credentials["dev"]["password"]      },
      tst: {
        endpoint: "https://cs.tst.psoft.umn.edu/PSIGW/PeopleSoftServiceListeningConnector",
        username: credentials["test"]["username"],
        password: credentials["test"]["password"]      },
      ent: {
        endpoint: "https://cs.qat.psoft.umn.edu/PSIGW/PeopleSoftServiceListeningConnector",
        username: credentials["qat"]["username"],
        password: credentials["qat"]["password"]      },
      prd: {
        endpoint: "https://cs.myu.umn.edu/PSIGW/PeopleSoftServiceListeningConnector",
        username: credentials["production"]["username"],
        password: credentials["production"]["password"]
      }
    }
  end
end
