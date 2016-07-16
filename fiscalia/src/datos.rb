require 'active_record'
require 'pg' # postgresql

ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    encoding: "unicode",
    database: "matrix",
    username: "postgres",
    password: ""
)

class User < ActiveRecord::Base
end
