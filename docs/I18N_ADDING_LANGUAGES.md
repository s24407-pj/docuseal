# I18n System - Adding New Languages Guide

This guide explains how to add support for a new language using the modular i18n architecture.

## Prerequisites

- Ruby on Rails application knowledge
- Basic understanding of YAML
- JavaScript module system knowledge
- Familiarity with the application's features

## Step-by-Step Process

### 1. Register the New Locale

#### In Rails Configuration

Edit `config/application.rb`:

```ruby
config.i18n.available_locales = %i[
  en en-US en-GB es-ES fr-FR pt-PT de-DE it-IT nl-NL
  es it de fr nl pl uk cs pt he ar ko ja
  xx  # Add your new locale code here (e.g., sv for Swedish, tr for Turkish)
]
```

### 2. Create Backend Translation Files

#### Directory Structure

Create a new directory for your locale:

```bash
mkdir -p config/locales/xx
```

Where `xx` is your language code (ISO 639-1).

#### Create Module Files

Create the following files in `config/locales/xx/`:

1. **common.yml** - Common UI elements
   ```yaml
   xx:
     save: # Translate "Save"
     delete: # Translate "Delete"
     cancel: # Translate "Cancel"
     # ... etc
   ```

2. **auth.yml** - Authentication
   ```yaml
   xx:
     sign_in: # Translate "Sign In"
     sign_up: # Translate "Sign Up"
     password: # Translate "Password"
     # ... etc
   ```

3. **forms.yml** - Forms and documents
4. **templates.yml** - Template management
5. **submissions.yml** - Submission management
6. **settings.yml** - Settings and configuration
7. **users.yml** - User and team management

#### Translation Template

You can use the Polish files as a template:

```bash
# Copy Polish structure and translate
cp config/locales/pl/common.yml config/locales/xx/common.yml
# Edit xx/common.yml and translate all values
```

### 3. Add Frontend Translations

#### Template Builder

Edit `app/javascript/template_builder/i18n.js`:

```javascript
// Add your language constant
const xx = {
  analyzing_: 'Analyzing...',  // Translate
  download: 'Download',        // Translate
  // ... translate all keys
}

// Add to export
export { en, es, it, pt, fr, de, nl, pl, xx }
```

Optional: Create a modular file:
```bash
mkdir -p app/javascript/i18n/template_builder
touch app/javascript/i18n/template_builder/xx.js
```

#### Submission Form

Edit `app/javascript/submission_form/i18n.js`:

```javascript
const xx = {
  email: 'Email',                    // Translate
  password: 'Password',              // Translate
  // ... translate all keys
}

// Update the i18n export
const i18n = { en, es, it, de, fr, pl, uk, cs, pt, he, nl, ar, ko, ja, xx }
```

### 4. Add Language Display Name

In all language files (`config/locales/*/common.yml`), add:

```yaml
language_xx: [Native name of your language]
```

Example:
```yaml
# In config/locales/pl/common.yml
language_sv: Svenska  # Swedish

# In config/locales/sv/common.yml
language_sv: Svenska  # Swedish
```

### 5. Test Your Translations

#### Restart the Rails Server

```bash
rails restart
```

The modular loader will automatically pick up new translation files.

#### Manual Testing Checklist

- [ ] Authentication pages (sign in, sign up, password reset)
- [ ] Template creation and editing
- [ ] Document signing flow
- [ ] Settings pages
- [ ] Email templates
- [ ] Error messages
- [ ] Form validations
- [ ] Navigation menus
- [ ] Help text and tooltips

#### Automated Testing

Create a test file:

```ruby
# spec/i18n/xx_translations_spec.rb
RSpec.describe 'XX translations' do
  let(:en_keys) { I18n.backend.send(:translations)[:en].keys }
  let(:xx_keys) { I18n.backend.send(:translations)[:xx].keys }
  
  it 'has all required translation keys' do
    expect(xx_keys).to match_array(en_keys)
  end
  
  it 'has no empty translations' do
    translations = I18n.backend.send(:translations)[:xx]
    empty_keys = translations.select { |k, v| v.blank? }
    
    expect(empty_keys).to be_empty, 
      "Found empty translations: #{empty_keys.keys.join(', ')}"
  end
end
```

### 6. Handle Special Cases

#### Date and Time Formats

Create `config/locales/xx.yml`:

```yaml
xx:
  date:
    formats:
      default: "%d/%m/%Y"
      long: "%B %d, %Y"
    month_names: [~, January, February, March, April, May, June, July, August, September, October, November, December]
    abbr_month_names: [~, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
  time:
    formats:
      default: "%a, %d %b %Y %H:%M:%S %z"
      long: "%B %d, %Y %H:%M"
      short: "%d %b %H:%M"
```

#### Pluralization

For languages with complex pluralization rules:

```yaml
xx:
  document:
    one: "dokument"
    few: "dokumenty"
    many: "dokumentów"
    other: "dokumentów"
```

### 7. Documentation

Document your translation in the language guide:

```bash
cp docs/I18N_POLISH_GUIDE.md docs/I18N_XX_GUIDE.md
# Edit and update for your language
```

### 8. Submit Your Contribution

1. Create a feature branch:
   ```bash
   git checkout -b feature/add-xx-language
   ```

2. Commit your changes:
   ```bash
   git add config/locales/xx/
   git add app/javascript/template_builder/i18n.js
   git add app/javascript/submission_form/i18n.js
   git commit -m "Add XX (Language Name) translations"
   ```

3. Push and create a pull request:
   ```bash
   git push origin feature/add-xx-language
   ```

## Translation Best Practices

### 1. Consistency

- Use consistent terminology throughout
- Maintain the same tone (formal/informal)
- Be consistent with capitalization rules

### 2. Context

- Consider the UI context when translating
- Short labels need concise translations
- Button text should be action-oriented

### 3. Technical Terms

- Preserve technical terms when appropriate
- Use localized terms when they exist and are commonly used

### 4. Parameters

- Maintain parameter placeholders: `%{name}`, `{variable}`
- Don't translate parameter names
- Ensure parameters work in your language's sentence structure

### 5. HTML and Formatting

- Preserve HTML tags in `_html` suffixed keys
- Maintain formatting characters (newlines, spaces)
- Test HTML rendering after translation

### 6. Length

- Be aware of UI space constraints
- Test that translations fit in buttons and form fields
- Use abbreviations sparingly and only when clear

## Example: Adding Swedish (sv)

### 1. Register Locale

```ruby
# config/application.rb
config.i18n.available_locales = %i[... pl sv]
```

### 2. Create Files

```bash
mkdir -p config/locales/sv
touch config/locales/sv/{common,auth,forms,templates,submissions,settings,users}.yml
```

### 3. Translate

```yaml
# config/locales/sv/common.yml
sv:
  save: Spara
  delete: Radera
  cancel: Avbryt
  # ...
```

### 4. Add to JavaScript

```javascript
// app/javascript/template_builder/i18n.js
const sv = {
  save: 'Spara',
  delete: 'Radera',
  // ...
}

export { en, es, it, pt, fr, de, nl, pl, sv }
```

### 5. Test and Submit

```bash
rails server
# Test the application
git add .
git commit -m "Add Swedish (sv) translations"
git push origin feature/add-swedish-language
```

## Getting Help

If you need assistance:
1. Check existing translation files for reference
2. Open an issue with the "i18n" label
3. Ask in the Discord community
4. Consult the Rails I18n documentation

## Resources

- [I18n Architecture Documentation](./I18N_ARCHITECTURE.md)
- [Polish Language Guide](./I18N_POLISH_GUIDE.md)
- [Rails I18n Guide](https://guides.rubyonrails.org/i18n.html)
- [ISO 639-1 Language Codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)

---

Thank you for contributing to DocuSeal's internationalization effort!
