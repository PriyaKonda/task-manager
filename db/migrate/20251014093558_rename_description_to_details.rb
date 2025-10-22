class RenameDescriptionToDetails < Mongoid::Migration
  def self.up
    # Rename description to details using collection update
    Task.collection.update_many(
      { "description" => { "$exists" => true } },
      { 
        "$rename" => { "description" => "details" }
      }
    )
  end

  def self.down
    # Rename details back to description using collection update
    Task.collection.update_many(
      { "details" => { "$exists" => true } },
      { 
        "$rename" => { "details" => "description" }
      }
    )
  end
end
