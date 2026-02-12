# README
## QUESTIONS

## PRIORITIEs
* MIGRATE EVERYTHING TO WEB!!!!
* FIX ENTITY.RB DIALECT? : SHOULD NOT BE FIRST DIALECT AUTOMAGIC
* Found societies manually??
* CHECK FOR DUPLICATE EVENTS
* PROCCING OF ALL EVENT TYPES, ENTITIES
  * Language should NOT BELONG TO entity, but entity can have one language
* better names for entity relationships than political/etc.
* Name generation abberations: 
  * abberations for societies
  * hiercharcy can include multiple parents for houses/societies
* CC, CCC: groups of consonants: char(?) in pattern for naming
  * write out permissible groups of consonants
* Relations: remove excess fields

### DATABASE
* Indices for encyclopedium stuff??

## OBSIDIAN

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

### NOTES
* public/private
  * events: noted in the code block, private by default
  * entities: private by default, look for a file for the entity in the file directory by name
* rail db:migrate VERSION=0 cascade=true
* Obsidian Plugins
  * Folder Index
  * Link with alias
* git diff --stat $(git hash-object -t tree /dev/null)