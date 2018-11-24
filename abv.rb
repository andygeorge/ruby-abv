require 'yaml'
vault_file_path = ARGV[0]

vault_file = YAML.load_file(vault_file_path)
puts vault_file
