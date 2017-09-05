## Peoplesoft Course Class Data
A service for extracting University of MN course class data from an Oracle QAS endpoint and converting the denormalized XML rows into JSON.

Still a bit rough. Move along, nothing to see here.

## Development Setup

- Clone the repo: `git clone https://github.com/umn-asr/peoplesoft_course_class_data.git`
- Run `$ ./script/setup`
  - Installs gems and dependencies for development
  - Creates `credentials.yml` with SOAP connection credentials from LastPass in `config/`

## Running Tests

`$ bundle exec rake` will run the test suite

## License

© Regents of the University of Minnesota. All rights reserved.
