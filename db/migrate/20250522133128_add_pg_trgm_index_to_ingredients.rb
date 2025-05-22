class AddPgTrgmIndexToIngredients < ActiveRecord::Migration[7.1]
  def change
    execute <<~SQL
      CREATE INDEX index_ingredients_on_name_trgm
      ON ingredients USING gin (name gin_trgm_ops);
    SQL
  end
end
