class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :key
      t.string :description
      t.string :value
      t.boolean :boolean_value
      t.string :value1_ar
      t.string :value1_en
      t.string :value2_ar
      t.string :value2_en
      t.text :text1_ar
      t.text :text1_en
      t.text :text2_ar
      t.text :text2_en

      t.timestamps
    end
  end
end
