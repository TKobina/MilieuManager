class Composition < ApplicationRecord
  belongs_to :suplexeme, class_name: "Lexeme"
  belongs_to :sublexeme, class_name: "Lexeme"
end
