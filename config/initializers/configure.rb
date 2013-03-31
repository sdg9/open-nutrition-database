config_file   = Rails.root.join("config", "config.yml")
configuration = nil

if File.exists?(config_file)
  configuration = YAML.load(File.open(config_file)).symbolize_keys
else
  configuration = {
    upc_dot_org: ENV['UPC_DOT_ORG_KEY'],
    upc_dot_com: ENV['UPC_DOT_COM_KEY'],
    fat_secret_key: ENV['FATSECRET_KEY'],
    fat_secret_secret: ENV['FATSECRET_SECRET']
  }
end

UPC_DOT_ORG_KEY  = configuration[:upc_dot_org]
UPC_DOT_COM_KEY  = configuration[:upc_dot_com]
FATSECRET_KEY    = configuration[:fat_secret_key]
FATSECRET_SECRET = configuration[:fat_secret_secret]


FatSecret.init(FATSECRET_KEY,FATSECRET_SECRET)
