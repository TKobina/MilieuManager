# README
## QUESTIONS

## PRIORITIES
* CHANGE PRODUCTION CONFIG RELOAD_CODE BACK TO FALSE
* REMOVE BINDING.PRY FROM PRODUCTION!!!!
* ACTIVE.STORAGE SET TO LOCAL; MIGRATE TO AW3 PER PAAS
* MIGRATE EVERYTHING TO WEB!!!!
  * Implement export/import functionality
  * Upload from library?
* EVENTS
  * PROCCING OF ALL EVENT TYPES, ENTITIES
  * handle changing of event ydate
  * split proc, public out of code, it's really ony useful for initial stuff, and changing to private shouldn't reproc everything
  * check for duplicate events
  * Found societies manually!!
  * speed efficiency of milieu reproccing, problem of duplicating relations
* ENTITIES
  * Filter by type, letter
* RELATIONS
  * add references for relations (supid|infid); modify public/private relation here?
  * modify names for relations here??
  * better names for entity relationships than political/etc.
    * add table for relation names?? including reversed names/roles/titles??
    * Milieu, Primary Kind, Secondary Kind, Relation Value, suptoinf, inftosup
    * means removing some parts of relations?? kind and value?? 
      - society of /
      - house of /
      - child / parent
      - nation of / 
      - [title of] /
      - adopted of
      - spouse/husband/wife(???) 
      - consort of / consortee
      - exile of / exile
      - divorcee(?) / divorced by
      - member of(?)
      - founder of(?) / founded by
      - creator of(?) / created by
      - owner of(?) / owned by

* LANGUAGE
  * BASE_ABBERATIONS: WHERE WILL SOURCE BE??
  * LEXEMES
    * Filter by type, letter
* NAMING
  * CC, CCC: groups of consonants: char(?) in pattern for naming
    * write out permissible groups of consonants
  * Name generation abberations: 
    * abberations for societies
    * hiercharcy can include multiple parents for houses/societies
* STORIES
  * Link to Lexemes(??)
* Sidebar
  * Choose between lexemes, entities, & chronology?
  * https://stackoverflow.com/questions/77197494/how-to-structure-navbar-with-side-bar-in-ruby-on-rails
  *

### DATABASE
* 

### NOTES
* Event Formatting
  * "## indicates title
  * Each line between ``` and ``` should be procc'd (has details about how to process event)
  * "proc | event/story/entity | public/private" in the code block tells the efile to process it
  * public in the code block indicates entity/event is public; otherwise, it's private
  * Everything between titles not in a code block is are details
  * public details between ~ and ~
  * Specifics
    * formation | name-eid | kind | creator-eid | public
    * founding | name-eid | kind | status | parentname-eid | public
    * birth | name-eid | gender | parent-parentname-eid | public
    * adoption | entity-eid | name-eid | newname-eid | public
    * exile | entity-eid | name-eid | newname-eid | public
    * raising | entity-eid| name-eid | title | newname-eid | public
    * claiming | name-eid | claimed-eid | kind | public
    * disclaiming | name-eid | disclaimed-eid | kind | public
    * hiring | entity-eid | name-eid | title | public
    * firing | entity-eid | name-eid | public
    * death | name-eid | public
* public/private
  * events: noted in the code block, private by default
  * entities: private by default, look for a file for the entity in the file directory by name
* Stories
  * If there is ANY private text in a chapter (between ~ and ~), that chapter will be marked private
* Obsidian Plugins
  * Folder Index
  * Link with alias

#### Rails Commands
* RAILS_ENV=production rails c

#### Rails Assets
* Issue with loading CSS files: had to do rake assets:clobber ; rails assets:precompile

#### Rails Migrations
* rails db:migrate VERSION=0 cascade=true
  * rails db:migrate:primary

#### Git
* git diff --stat $(git hash-object -t tree /dev/null)

#### Creating Solid Cache in DB
CREATE TABLE solid_cache_entries (
    id BIGSERIAL PRIMARY KEY,
    key BYTEA NOT NULL,
    value BYTEA NOT NULL,
    created_at TIMESTAMP NOT NULL,
    key_hash BIGINT NOT NULL,
    byte_size INTEGER NOT NULL
    );

    CREATE INDEX index_solid_cache_entries_on_byte_size
    ON solid_cache_entries (byte_size);

    CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size
    ON solid_cache_entries (key_hash, byte_size);

    CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash
    ON solid_cache_entries (key_hash);