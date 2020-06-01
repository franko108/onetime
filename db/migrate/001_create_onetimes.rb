Sequel.migration do
  up do
    create_table :onetimes do
      primary_key :id
      String :uuid
      String :content
      DateTime :created_at
    end
  end

  down do
    drop_table :onetimes
  end
end
