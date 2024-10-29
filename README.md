# Peoplesoft Course Class Data

A service for extracting University of MN course class data from an Oracle QAS endpoint and converting the denormalized XML rows into JSON.

Still a bit rough. Move along, nothing to see here.

## Development Setup

- Clone the repo: `git clone https://github.com/umn-asr/peoplesoft_course_class_data.git`
- Run `$ ./script/setup`
  - Installs gems and dependencies for development
  - Creates `credentials.yml` with SOAP connection credentials from LastPass in `config/`

## Running Tests

`./script/test` will run the test suite

## Testing the data feed

If you need to test that the query into Peoplesoft is working - for example, if there was a change in PeopleSoft TST and they want to make sure the query still works - do the following:

1) Do the development setup above
1) Run `./script/docker` to start a Docker container for local development
1) Run the following: `bundle exec rake peoplesoft_course_class_data:download\[tst\]` 
1) This will take a long time, but you can see if it is returning any data by looking in the `tmp` directory.  If you start seeing files appearing that have the filename like `course_for__tst__UMNDL__UMNDL__1225.json` or `class_for__tst__UMNDL__UMNDL__1225.xml`, then the process is getting results from the Peoplesoft service.
 
## Deployment

`./script/deploy <environment>` deploys to the provided environment.

## License

© Regents of the University of Minnesota. All rights reserved.
