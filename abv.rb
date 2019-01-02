require 'yaml'
require 'parseconfig'

vault_name = ARGV[0]
vault_file_path = ARGV[1]

abv_config_path = "#{ENV['HOME']}/.abv.cfg"
abv_config_params = ParseConfig.new(abv_config_path).params
ansible_config_path = abv_config_params["ansible"]["config_file_path"].sub("~","#{ENV['HOME']}")
vault_identity_list = ParseConfig.new(ansible_config_path)["defaults"]["vault_identity_list"].split(", ")
vault_identity_hash = Hash[vault_identity_list.map{|p| k, v = p.split("@")}]

vault_file_contents = YAML.load_file(vault_file_path)
vault_string = "#{vault_file_contents[vault_name]}"
vault_string_descriptor = vault_string.lines.first.chomp
vault_id = vault_string_descriptor.split(";").last
vault_password_file = vault_identity_hash[vault_id].sub("~","#{ENV['HOME']}")

#puts "var name: #{vault_name}\nvault id: #{vault_id}\nvault pw file: #{vault_password_file}\n#{vault_string}"

system("echo '#{vault_string}' | ansible-vault decrypt --vault-password-file #{vault_password_file}")
puts "\n"
