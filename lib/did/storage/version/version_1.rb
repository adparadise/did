

module Did
  module Storage
    module Version
      class Version1
        def number
          1
        end

        def update(profile_path)
          database_path = Version::database_path(profile_path)
          puts "initializing DID database: #{database_path}"
          db = SQLite3::Database.new(database_path.to_s)
          schema_lines.each do |line|
            db.execute(line)
          end
          db.close
        end

        private

        def schema_lines
          ['CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);',
           'CREATE TABLE "sittings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' + 
           '"start_time" datetime, "end_time" datetime, "current" boolean, "end_span_id" integer);',
           'CREATE TABLE "spans" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' + 
           '"start_time" datetime, "end_time" datetime, "sitting_id" integer, "sitting_start" boolean, "sitting_end" boolean);',
           'CREATE TABLE "spans_tags" ("span_id" integer, "tag_id" integer);',
           'CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "label" varchar(255));',
           'CREATE INDEX "index_sittings_on_current" ON "sittings" ("current");',
           'CREATE INDEX "index_spans_tags_on_tag_id" ON "spans_tags" ("tag_id");',
           'CREATE UNIQUE INDEX "index_tags_on_label" ON "tags" ("label");',
           'CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");']
        end
      end
    end
  end
end
