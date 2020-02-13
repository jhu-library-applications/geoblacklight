# geoblacklight
Johns Hopkins University Geoblacklight Project

## Installation

### Dependencies

* [Ruby](https://www.ruby-lang.org/en/) 2.6.5
* [Java](https://www.java.com/en/) 8 or greater (Solr)
* [Node.js](https://nodejs.org/en/) (yarn)

[GoRails](https://gorails.com/setup) has great Ruby on Rails setup instructions for macOS, Ubuntu, and Windows.

### Clone the Project

```bash
cd <your project directory>
git clone git@github.com:jhu-sheridan-libraries/geoblacklight.git
```

### Configuration

Duplicate the .example files in the project and remove the .example string from each of their filename. Configure each file as necessary, or keep the default values.

cp .example.env.development .env.development  
cp .example.env.test .env.test  
cp config/database.yml.example config/database.yml  

* config/database.yml.example => config/database.yml
* .example.env.development => .env.development
* .example.env.test => .env.test

### Bundle RubyGems

Test with Bundler 2.1.4

```bash
bundle
```

### Run the Application

The rake task below will spin up Solr, index the test fixture documents, and start Puma the default Rails web server.

```bash
bundle exec rake jhu:server
```

* View the application at [http://localhost:3000](http://localhost:3000)
* View the Solr admin panel at [http://localhost:8983](http://localhost:8983)

### Optional - Index UMD documents from B1G Geoportal

```bash
bundle exec rake jhu:big_index_umd_data
```

### Run the Test Suite

Stop any instances of GeoBlacklight before running this command.

```bash
RAILS_ENV=test bundle exec rake ci
```

----

### Homepage Imagery

* [Hackerman Maps](https://hub.jhu.edu/2019/02/27/koot-maps-hackerman/)
* [Maryland LiDAR](https://geo.btaa.org/catalog/33e12797d4c846bd808fbe0239574040)
* [Fish and Game](https://geo.btaa.org/catalog/93299141-4daa-4091-9b25-7903dbf1ef8d)
* [Watersheds](https://geo.btaa.org/catalog/d892d304-3890-4ee5-8128-f72007db0ed1)
