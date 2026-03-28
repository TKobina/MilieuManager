# Milieu Manager

## Description
! Insert Description Here !

## Prerequisites
- Rails 8.1.2
- Ruby 3.3.7
- PostgreSQL 16.10

## Setup
```bash
```

## Useage

### Stories
### Entities
### Events
### Instructions
* In each event, a list of "instructions" can be listed. These instructions are used to manage entities, entity status, and entity relations. Here are the currently implemented instructions:
* Instruction Formatting
  * Formation: creates an "entity" which may be a variety of kinds, including the top "container" for the milieu
    * formation | name-eid | kind | creator-eid | public
  * Founding: creates 
  * founding | name-eid | kind | status | parentname-eid | public
  * birth | name-eid | gender | parent-parentname-eid | public
  * adoption | entity-eid | name-eid | newname-eid | public
  * exile | entity-eid | name-eid | newname-eid | public
  * raising | entity-eid| name-eid | title | newname-eid | public
  * claiming | name-eid | claimed-eid | kind | newname-eid  | public
  * disclaming | entity-eid | name-eid | newname-eid | public
  * hiring | entity-eid | name-eid | title | public
  * firing | entity-eid | name-eid | public
  * death | name-eid | public
  * link | entity-eid
### Relations
### Statuses
### Languages
### Lexemes

## Known Issues
* CREATE DEFAULT "ENGLISH" LANGUAGE??
  * If no language on entity, sort according to English??
* PASSWORD RESET & EMAIL CONFIRMATION
* Relations aren't being cleared when entities are being cleared??
* New entitie's not propogating "name" field in reference, failing saving of new reference the first time.
* Formatting lists for entities' displays

## Roadmap
* CHANGE PRODUCTION CONFIG RELOAD_CODE BACK TO FALSE
* REMOVE BINDING.PRY BEFORE UPLOADING!
* LEXICON: Permit linking of other words in text (e.g., "see also")
* Implement uploading/display of maps/images
* Link to events, lexemes as link to entities
* If there are issues with instructions, display them as errors
* Make events dynamic form (drop-down for classes of instructions??)
* Add "Back" buttons at tops of pages
* Entity properties all private??
* Edit properties (statuses)??
* EVENTS
  * PROCCING OF ALL EVENT TYPES, ENTITIES
  * check for duplicate events
  * Found societies manually!!
  * speed efficiency of milieu reproccing
* Delete buttons (maybe some others?): make them look like buttons 
* ENTITIES
  * Filter by type, letter
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
* Sidebar
  * Choose between lexemes, entities, & chronology?
  * https://stackoverflow.com/questions/77197494/how-to-structure-navbar-with-side-bar-in-ruby-on-rails
  *
