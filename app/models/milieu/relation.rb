class Relation < ApplicationRecord
  belongs_to :superior, class_name: "Entity"
  belongs_to :inferior, class_name: "Entity"
  belongs_to :relclass
  belongs_to :event

  REVERSE = {
    "child": "parent",
    "consort": "consortee",
    "spouse": "spouse",
    "societal": "society of",
    "political": "politic of",
    "first of": "first",
    "second of": "second",
    "third of": "third",
    "exile of": "exile"
  }

  def <=>(other)
    self.event.ydate.value <=> other.event.ydate.value
  end

  def relrev(rname) = REVERSE[rname.to_sym] || "unknown"
end
