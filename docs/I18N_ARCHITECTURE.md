# Modular I18n System Documentation

## Overview

This document describes the modular internationalization (i18n) system implemented in DocuSeal. The system is designed to be maintainable, scalable, and easy to manage.

## Architecture

### Backend (Rails)

The backend i18n system is organized into modular YAML files located in `config/locales/<locale>/` directories. Each locale has its own subdirectory containing feature-specific translation files.

#### Directory Structure

```
config/locales/
├── i18n.yml                    # Original monolithic file (kept for backward compatibility)
├── i18n_modular_loader.rb      # Initializer for loading modular translations
└── pl/                         # Polish translations (modular)
    ├── common.yml             # Common UI elements and actions
    ├── auth.yml               # Authentication and authorization
    ├── forms.yml              # Forms and documents
    ├── templates.yml          # Template management
    ├── submissions.yml        # Submission management
    ├── settings.yml           # Settings and configuration
    └── users.yml              # User and team management
```

#### Module Categories

1. **common.yml** - Common translations used across the application
   - Actions (save, delete, update, etc.)
   - Status messages (success, error, warning)
   - Common UI elements (yes, no, ok, cancel)
   - Language names
   - General greetings

2. **auth.yml** - Authentication related translations
   - Sign in/sign up
   - Password management
   - Two-factor authentication (2FA)
   - Email and phone verification
   - Session management

3. **forms.yml** - Form and document related translations
   - Form status and actions
   - Document signing
   - Field types (text, signature, date, etc.)
   - Drawing and typing actions
   - Validation messages

4. **templates.yml** - Template management translations
   - Template CRUD operations
   - Parties (first party, second party, etc.)
   - Folder management
   - Template sharing
   - API and embedding

5. **submissions.yml** - Submission management translations
   - Submission status and actions
   - Recipients management
   - Signers
   - Email and SMS invitations
   - Expiration settings
   - Event logging

6. **settings.yml** - Settings and configuration translations
   - Account settings
   - Integration settings (Stripe, Salesforce, etc.)
   - Email and SMS configuration
   - Security settings
   - PDF signature settings
   - Personalization

7. **users.yml** - User and team management translations
   - User roles and permissions
   - Team management
   - Account management
   - Support and help

### Frontend (JavaScript)

The frontend i18n system uses inline JavaScript objects for translations. Two main files handle client-side translations:

- `app/javascript/template_builder/i18n.js` - Template builder UI translations
- `app/javascript/submission_form/i18n.js` - Submission form UI translations

Each file exports translation objects for multiple languages, including Polish (pl).

## How It Works

### Backend Loading

The modular translation files are automatically loaded through the `config/initializers/i18n_modular_loader.rb` initializer, which:

1. Scans the `config/locales/*/` directories for YAML files
2. Adds found files to the I18n load path
3. Reloads the I18n backend to include new translations

### Key Organization

Translation keys are organized hierarchically with clear naming conventions:

- Use descriptive snake_case names
- Group related keys under common prefixes
- Include parameter placeholders where needed (`%{param}`)
- Use HTML-safe suffixes (`_html`) for translations containing HTML

Example:
```yaml
pl:
  form_has_been_declined_on_html: 'Formularz został odrzucony o <span class="font-semibold">%{time}</span>'
  user_has_been_invited: Użytkownik został zaproszony
  count_documents_signed_with_html: "<b>%{count}</b> dokumentów podpisanych za pomocą"
```

## Adding New Translations

### Backend (Rails)

1. Identify the appropriate module for your translation
2. Open the corresponding YAML file in `config/locales/<locale>/`
3. Add your translation key and value
4. Restart the Rails server for the changes to take effect

Example:
```yaml
# config/locales/pl/forms.yml
pl:
  new_field_type: Nowy typ pola
  field_configuration: Konfiguracja pola
```

### Frontend (JavaScript)

1. Open the appropriate JavaScript i18n file
2. Locate the language object (e.g., `const pl = { ... }`)
3. Add your translation key and value
4. Build the frontend assets if needed

Example:
```javascript
const pl = {
  new_field_type: 'Nowy typ pola',
  field_configuration: 'Konfiguracja pola'
}
```

## Using Translations

### In Rails Views

```erb
<%= t(:form_has_been_completed) %>
<%= t(:hello_name, name: @user.name) %>
<%= t(:count_documents_signed_with_html, count: @count).html_safe %>
```

### In Rails Controllers

```ruby
flash[:notice] = I18n.t(:user_has_been_invited)
render json: { error: I18n.t('form_has_been_expired') }
```

### In JavaScript

```javascript
import { en, es, it, pt, fr, de, nl, pl } from './i18n'

const i18n = { en, es, it, pt, fr, de, nl, pl }
const locale = 'pl'
const translations = i18n[locale] || i18n.en

console.log(translations.form_has_been_completed)
```

## Polish Translation Status

Polish translations have been fully implemented across all modules:

- ✅ Common UI elements
- ✅ Authentication and authorization
- ✅ Forms and documents
- ✅ Template management
- ✅ Submission management
- ✅ Settings and configuration
- ✅ User and team management
- ✅ Frontend template builder
- ✅ Frontend submission form

## Benefits of Modular Architecture

1. **Maintainability** - Easy to find and update translations by feature area
2. **Scalability** - New modules can be added without affecting existing ones
3. **Organization** - Clear separation of concerns makes collaboration easier
4. **Performance** - Only necessary translations can be loaded when needed (future enhancement)
5. **Debugging** - Issues with translations are easier to locate and fix
6. **Version Control** - Changes to translations are more granular in git history

## Future Improvements

1. Implement lazy loading for frontend translations
2. Add translation coverage reports
3. Create automated translation verification tools
4. Add support for locale-specific date/time formats
5. Implement pluralization helpers for complex cases
6. Add context-aware translations for ambiguous terms

## Backward Compatibility

The original monolithic `config/locales/i18n.yml` file is preserved to ensure backward compatibility. The modular system supplements this file without replacing it. Both systems work together seamlessly.

## Contributing

When adding new features that require translations:

1. Add English translations first
2. Identify the appropriate module for the translations
3. Update all language modules with the new keys
4. Use Polish translations that are accurate and contextually appropriate
5. Test translations in the UI to ensure they fit properly
6. Document any special translation requirements

## Resources

- [Rails I18n Guide](https://guides.rubyonrails.org/i18n.html)
- [DocuSeal Documentation](https://www.docuseal.com/docs)
- [Polish Language Style Guide](https://pl.wikipedia.org/wiki/Poradnia_j%C4%99zykowa_PWN)

## Contact

For questions about the i18n system or Polish translations, please:
- Open an issue on GitHub
- Contact the development team
- Join the Discord community for real-time help
