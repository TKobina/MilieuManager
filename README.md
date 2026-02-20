# README
## QUESTIONS

## PRIORITIES
* MIGRATE EVERYTHING TO WEB!!!!
  * Implement export/import functionality
* EVENTS
  * CHECK FOR DUPLICATE EVENTS
  * PROCCING OF ALL EVENT TYPES, ENTITIES
  * Found societies manually!!
* ENTITIES
  * UNKNOWN FOR EVERY HOUSE, REMOVE HOUSE FROM EVENT BIRTHS??
  * FIX ENTITY.RB DIALECT? : SHOULD NOT BE FIRST DIALECT AUTOMAGIC
  * WHERE DO ENTITY DETAILS COME FROM? EVENTS?
    * How do we ensure they are restored after doing an event proc?
  * Implement EID generation for entities as with Lexemes
* RELATIONS
  * better names for entity relationships than political/etc.
* PROPERTIES
  * Why are properties preventing Milieu.destroy_all????
* LANGUAGE
  * BASE_ABBERATIONS: WHERE WILL SOURCE BE??
* NAMING
  * CC, CCC: groups of consonants: char(?) in pattern for naming
    * write out permissible groups of consonants
  * Name generation abberations: 
    * abberations for societies
    * hiercharcy can include multiple parents for houses/societies

## EVENTS
* Event Formatting
  * "## indicates title
  * Each line between ``` and ``` should be procc'd (has details about how to process event)
  * "proc | event/story/entity | public/private" in the code block tells the efile to process it
  * public in the code block indicates entity/event is public; otherwise, it's private
  * Everything between titles not in a code block is are details
  * public details between ~ and ~
  * Specifics
    * formation | name-eid | "World" | milieu
    * founding | name-eid | kind | status | parentname-eid
    * birth | name-eid | gender | parent-parentname-eid
    * adoption | entity-eid | name-eid | newname-eid
    * exile | entity-eid | name-eid
    * raising | entity-eid| name-eid | title | newname-eid
    * claiming | name-eid | claimed-eid | kind
    * disclaiming | name-eid | disclaimed-eid | kind
    * hiring | entity-eid | name-eid | title
    * firing | entity-eid | name-eid
    * death | name-eid


  

### DATABASE
* 

### NOTES
* public/private
  * events: noted in the code block, private by default
  * entities: private by default, look for a file for the entity in the file directory by name
* rail db:migrate VERSION=0 cascade=true
* Obsidian Plugins
  * Folder Index
  * Link with alias
* git diff --stat $(git hash-object -t tree /dev/null)
* Issue with loading CSS files: had to do rake assets:clobber ; rails assets:precompile