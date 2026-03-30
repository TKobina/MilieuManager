# 0.9.3.1
* FIX: sorting for References, Entities broken

# v0.9.3
* FIX: Cancel new lexeme resolved
* FIX: Delete buttons location & styling for Events, Stories, & Lexemes
* FIX: Added a little height to lexemes table header
* CHANGE: Pad yielded part of body in application layout
* CHANGE: Entities' information outlined

# v0.9.2
* FIX: Font: Ă and ă characters not working with Lëdru font
* FIX: Lexemes: definitions, meanings, etc. should not be in header font
* FIX: Entities: Events in Show Entity not listed chronologically
* FIX: Lexemes: deleting lexeme not working
* FIX: Instructions: Claiming: need to be able to change name with a claiming
* FIX: Stories: Padding to left of story-writing text field
* FIX: LEXEMES: Error if try to delete Lexeme that has derivatives/roots
* FIX: RELCLASSES: bottomtop vs topbottom
* CHANGE: Events: add instruction to link event to entity (eg, ravaging of Nä'drë'e)
* CHANGE: Lexemes: sub/sup-lexemes now sorted alphabetically
* CHANGE: Lexemes: tabled the index
* CHANGE: Stories: Form: Change "Chapter" to "Chapter Number"
* CHANGE: Events, Entities, Stories: tabled the index
* CHANGE: Relclasses: tabled
* CHANGE: Moved "cancel" to before forms
* ADD: changed stories index to table for @owner, added word counts to table
* ADD: styling for buttons, links

# v0.9.1
* FIX: Counting issues with maxlexeid and spaces/multiple-character letters
* ADD: Firing functionality added

# v0.9.0
* ADD: Disclaiming, Hiring functionality added
* FIX: @owner issue with lexeme index

# v0.8.6
* ADD: display chapter nummers in index if @owner
* FIX: suplex/sublex display for lexemes breaking things
* FIX: bulleted lexeme index

# v0.8.5
* FIX: raisings connect to wrong entity
* FIX: Founding of säl's are failing
* FIX: Outline formatting in markdown
* FIX: H4 formatting

# v0.8.4
* FIX: RelationEntity / Relationships mispaired by filter_joint_records
* FIX: Milieu: proc_chronology not occurring on update of "proc" in Events

# v0.8.3
* FIX: Reference name change fix wasn't working; adoptions, raisings stopped working
* FIX: Spacing on Relations was off

# v0.8.2
* FIX: Fonts served properly from server (had to convert otf to woff)
* FIX: Hide "Relations" heading if there are no relations
* FIX: Reference name changes when Entity name changes

# v0.8.1
* ADD: Delete event functionality
* ADD: In Events and Entities, hide fields that aren't populated
* FIX: Grayspace at top of page??
* FIX: Fix sort order: h
* FIX: References: generated references missing names!
* FIX: Story: on creation, ignores "public" and sets to private
* FIX: References: on edit, redirect to entity path
* FIX: i (in events) defaulting to 0 after an edit
* FIX: Next EID not working??