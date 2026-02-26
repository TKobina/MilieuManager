# README
## QUESTIONS

## PRIORITIES
* FINISH CONVERTING LANGUAGES TO NATION, ENTITIES TO LANGUAGES
* FINISH BUILDING OUT RELCLASSES
* MIGRATE EVERYTHING TO WEB!!!!
  * Implement export/import functionality
* EVENTS
  * PROCCING OF ALL EVENT TYPES, ENTITIES
  * handle changing of event ydate
  * split proc, public out of code, it's really ony useful for initial stuff, and changing to private shouldn't reproc everything
  * check for duplicate events
  * Found societies manually!!
  * speed efficiency of milieu reproccing, problem of duplicating relations
* ENTITIES
  * FIX ENTITY.RB DIALECT? : SHOULD NOT BE FIRST DIALECT AUTOMAGIC
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
* rails db:migrate VERSION=0 cascade=true
  * rails db:migrate:primary
* Obsidian Plugins
  * Folder Index
  * Link with alias
* git diff --stat $(git hash-object -t tree /dev/null)
* Issue with loading CSS files: had to do rake assets:clobber ; rails assets:precompile
* Stories
  * If there is ANY private text in a chapter (between ~ and ~), that chapter will be marked private