# I18n System - Quick Start Guide

## Polish Language Support

DocuSeal now has complete Polish language support implemented through a modular i18n system.

## Switching to Polish

### For Users

1. **In the Application UI:**
   - Go to Settings → Account → Language
   - Select "Polski" from the dropdown
   - Save changes

2. **During Sign-up/Sign-in:**
   - The language selector is available on authentication pages
   - Choose "Polski" to use the Polish interface

### For Developers

1. **Set Default Locale:**
   ```ruby
   # config/application.rb
   config.i18n.default_locale = :pl
   ```

2. **Switch Locale in Controller:**
   ```ruby
   class ApplicationController < ActionController::Base
     around_action :switch_locale

     def switch_locale(&action)
       locale = params[:locale] || session[:locale] || I18n.default_locale
       I18n.with_locale(locale, &action)
     end
   end
   ```

3. **Set Locale for JavaScript:**
   ```javascript
   import { pl } from './i18n/template_builder/pl'
   
   // Use Polish translations
   const translations = pl
   ```

## Architecture Overview

### Backend (Rails)

```
config/locales/
├── pl/
│   ├── common.yml      # Common UI elements
│   ├── auth.yml        # Authentication
│   ├── forms.yml       # Forms & documents
│   ├── templates.yml   # Templates
│   ├── submissions.yml # Submissions
│   ├── settings.yml    # Settings
│   └── users.yml       # Users & teams
```

### Frontend (JavaScript)

```
app/javascript/
├── template_builder/i18n.js  # Template builder translations (includes pl)
├── submission_form/i18n.js   # Submission form translations (includes pl)
└── i18n/
    └── template_builder/
        └── pl.js            # Modular Polish translations
```

## Translation Coverage

✅ **100% Complete** for Polish language:

- **Backend:** All 7 modules fully translated (~1,000+ keys)
- **Frontend Template Builder:** All 187 keys translated
- **Frontend Submission Form:** All 99 keys translated

## Testing Polish Translations

### Manual Testing

1. Start the Rails server:
   ```bash
   rails server
   ```

2. Navigate to the application and switch language to Polski

3. Test key areas:
   - Sign in/Sign up pages
   - Template creation and editing
   - Form submission
   - Settings pages
   - User management

### Automated Testing

```ruby
# spec/i18n/pl_translations_spec.rb
RSpec.describe 'Polish translations' do
  it 'has all required keys' do
    en_keys = I18n.backend.send(:translations)[:en].keys
    pl_keys = I18n.backend.send(:translations)[:pl].keys
    
    expect(pl_keys).to match_array(en_keys)
  end
end
```

## Common Translation Patterns

### Backend (YAML)

```yaml
pl:
  # Simple translation
  save: Zapisz
  
  # With parameters
  hello_name: "Witaj %{name}"
  
  # HTML-safe content
  form_expired_at_html: 'Formularz wygasł o <span class="font-semibold">%{time}</span>'
  
  # Multiline content
  email_body: |
    Cześć,
    
    To jest treść e-maila.
```

### Frontend (JavaScript)

```javascript
const pl = {
  // Simple translation
  save: 'Zapisz',
  
  // With template variables
  draw_field: 'Narysuj pole {field}',
  
  // Nested values
  form_status: {
    pending: 'Oczekujące',
    completed: 'Zakończone'
  }
}
```

## Maintaining Translations

### Adding New Translations

1. Add English translation first
2. Identify the appropriate module
3. Add translation to all language files
4. Test in UI

### Example Workflow

```bash
# 1. Add to English
# config/locales/pl/forms.yml
pl:
  new_field_type: Nowy typ pola

# 2. Use in view
<%= t(:new_field_type) %>

# 3. Test
rails server
# Navigate to the page and verify
```

## Resources

- [Full I18n Architecture Documentation](./I18N_ARCHITECTURE.md)
- [Rails I18n Guide](https://guides.rubyonrails.org/i18n.html)
- [Polish Language Style Guide](https://pl.wikipedia.org/wiki/Poradnia_j%C4%99zykowa_PWN)

## Support

For issues or questions about Polish translations:
- Open an issue on GitHub with the "i18n" label
- Tag it as "Polish" or "pl"
- Provide context and screenshots if UI-related

## Contributors

Special thanks to all contributors who helped with Polish translations!

---

**Note:** The modular i18n system is designed to be scalable and maintainable. When adding new features, please update translations in all supported languages to maintain consistency.
