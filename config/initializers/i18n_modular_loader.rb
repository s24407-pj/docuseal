# frozen_string_literal: true

# Modular I18n Loader
# This initializer automatically loads translation files from locale subdirectories
# organized by feature modules for better maintainability and scalability

Rails.application.config.after_initialize do
  # Define the locales directory structure
  locales_dir = Rails.root.join('config', 'locales')
  
  # Load all YAML files from locale subdirectories
  locale_paths = []
  
  # Add modular locale files from subdirectories (pl/, en/, etc.)
  Dir.glob(locales_dir.join('*', '*.yml')).each do |file|
    locale_paths << file
  end
  
  # Add the modular paths to I18n load path if they exist
  unless locale_paths.empty?
    I18n.load_path += locale_paths.sort
    
    # Reload I18n backend to include new translations
    I18n.backend.load_translations
    
    Rails.logger.info "Loaded #{locale_paths.size} modular translation files"
  end
end
