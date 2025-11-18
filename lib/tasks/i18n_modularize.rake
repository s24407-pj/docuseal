# frozen_string_literal: true

namespace :i18n do
  desc 'Modularize i18n translations into separate files'
  task modularize: :environment do
    require 'yaml'

    # Load the monolithic i18n file
    i18n_file = Rails.root.join('config/locales/i18n.yml')
    translations = YAML.load_file(i18n_file)

    # Define module categories based on key patterns
    forms_patterns = %w[form_ field_ submit submitter template_ document_ upload draw signature
                        initials checkbox radio cells stamp payment phone]
    common_patterns = %w[language_ yes no ok cancel save saving update updating delete deleting remove removing
                         add adding create creating edit editing view viewing download downloading enabled disabled
                         required optional close closing open opening start starting stop stopping continue error
                         success warning info hi_there thanks powered_by privacy_policy]

    modules = {
      'auth' => %w[sign_in sign_up sign_out password forgot reset_password two_factor 2fa authenticate verify_],
      'forms' => forms_patterns,
      'submissions' => %w[submission_ completed pending awaiting declined expired signed],
      'users' => %w[user_ profile invite account_ team_ tenant_ role admin member viewer editor agent],
      'settings' => %w[settings preference config smtp email sms webhook integration storage notification],
      'emails' => %w[email_ send_ sent sms_ message_ notification_],
      'ui' => %w[button_ link_ modal_ dialog_ toast_ alert_ banner_ dropdown_ menu_],
      'navigation' => %w[home dashboard template submission archive search filter sort page],
      'common' => common_patterns
    }

    # Excluded locales
    excluded_locales = %w[en-US en-GB es-ES fr-FR pt-PT de-DE it-IT nl-NL]

    # Create separate files for each locale and module
    translations.each do |locale, keys|
      next if excluded_locales.include?(locale.to_s)

      puts "Processing locale: #{locale}"

      # Categorize keys
      categorized = Hash.new { |h, k| h[k] = {} }
      uncategorized = {}

      keys.each do |key, value|
        key_str = key.to_s
        category = nil

        # Find matching category
        modules.each do |mod_name, patterns|
          if patterns.any? { |pattern| key_str.include?(pattern) }
            category = mod_name
            break
          end
        end

        if category
          categorized[category][key] = value
        else
          uncategorized[key] = value
        end
      end

      # Write categorized translations to files
      locale_dir = Rails.root.join('config/locales', locale.to_s)
      FileUtils.mkdir_p(locale_dir)

      categorized.each do |category, cat_keys|
        next if cat_keys.empty?

        output = { locale => cat_keys }
        output_file = locale_dir.join("#{category}.yml")
        File.write(output_file, output.to_yaml)
        puts "  Created #{output_file} with #{cat_keys.size} keys"
      end

      # Write uncategorized to common
      next if uncategorized.empty?

      output = { locale => uncategorized }
      output_file = locale_dir.join('other.yml')
      File.write(output_file, output.to_yaml)
      puts "  Created #{output_file} with #{uncategorized.size} uncategorized keys"
    end

    puts "\nModularization complete!"
    puts "Original file preserved at: #{i18n_file}"
    puts 'New modular files created in: config/locales/<locale>/*.yml'
  end
end
