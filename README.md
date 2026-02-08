# README
## QUESTIONS

## PRIORITIEs
* IF EVENTS CHANGE, REPROC THINGS FROM EVENTS, BUT DON'T TOUCHE LANGUAGE; SHOULD BE INDEPENDENT
  * Here's the problem: language is tied to nation, which is created from event
  * Better to create files for each word?
  * No; can divide words up into different files, but yes, dictionary can exist in Obsidian??
  * Or do we maintain the rails server, and export to obsidian?? But not update the stuff in Obsidian directly?
  * SHOULDN'T GO BOTH WAYS; ONE OR THE OTHER
  * WHERE DO I WANT TO WRITE?? WHERE WILL IT BE THE MOST CONVENIENT??
  * Web, additional backup considerations, have to code some more stuff up front, BUT. A lot more flexibility with sharing, how I display and format stuff, all that stuff. What does Obsidian give me, really, other than easy linking ititially, with Aliases and such?
  * MIGRATE TO WEB!!!!
* FIX ENTITY.RB DIALECT? : SHOULD NOT BE FIRST DIALECT AUTOMAGIC
* CHECK FOR DUPLICATE EVENTS
* PROCCING OF ALL EVENT TYPES, ENTITIES
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