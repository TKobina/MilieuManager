# README
## QUESTIONS

## PRIORITIEs
* CHECK FOR DUPLICATE EVENTS
* EVENT IMPORT FORMATTING AND PROCCING OF ALL EVENT TYPES, ENTITIES
* better names for entity relationships than political/etc.
* Name generation abberations: 
  * abberations for societies
  * hiercharcy can include multiple parents for houses/societies
* On name delection, adjust stats(?)
* CC, CCC: groups of consonants: char(?) in pattern for naming
  * write out permissible groups of consonants
* ID's for files??
* IF EVENTS CHANGE, REPROC THINGS FROM EVENTS
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
    * raising | name-eid | entity-eid | title | newname-eid

### NOTES
* public/private
  * events: noted in the code block, private by default
  * entities: private by default, look for a file for the entity in the file directory by name
* rail db:migrate VERSION=0 cascade=true
* Obsidian Plugins
  * Folder Index
  * Link with alias
* git diff --stat $(git hash-object -t tree /dev/null)