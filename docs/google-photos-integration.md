# Google Photos Integration Plan

## Overview

Integrate Google Photos to allow users to import photos from their Google Photos library into Doce Lar galleries.

## Obtaining Google API Credentials

### Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" → "New Project"
3. Enter project name (e.g., "Doce Lar")
4. Click "Create"

### Step 2: Enable the Photos Library API

1. In the sidebar, go to "APIs & Services" → "Library"
2. Search for "Google Photos Library API"
3. Click on it and click "Enable"

### Step 3: Configure OAuth Consent Screen

1. Go to "APIs & Services" → "OAuth consent screen"
2. Choose "External" user type
3. Fill in required fields:
   - App name: Doce Lar
   - User support email: your email
   - Developer contact: your email
4. Click "Save and Continue"
5. On Scopes page, add:
   - `https://www.googleapis.com/auth/photoslibrary.readonly`
   - `https://www.googleapis.com/auth/photoslibrary.sharing`
6. Click "Save and Continue"
7. Add test users (your email for testing)
8. Click "Save and Continue"

### Step 4: Create OAuth 2.0 Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. Application type: "Web application"
4. Name: "Doce Lar Web Client"
5. Authorized redirect URIs:
   - Development: `http://localhost:3000/oauth/google_photos_callback`
   - Production: `https://yourdomain.com/oauth/google_photos_callback`
6. Click "Create"

### Step 5: Copy Credentials

You will see a dialog with:
- **Client ID**: `xxxxx.apps.googleusercontent.com`
- **Client Secret**: `GOCSPX-xxxxx`

### Environment Variables Setup

```bash
# .env or environment
export GOOGLE_CLIENT_ID="your_client_id.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="your_client_secret"
```

Or add to `config/credentials.yml.enc`:

```bash
rails credentials:edit
```

Add:
```yaml
google_photos:
  client_id: your_client_id.apps.googleusercontent.com
  client_secret: your_client_secret
```

### Important Notes

- **Test Mode**: Until your app is verified by Google, users will see "This app isn't verified" warning
- **Verification**: Required for production - submit for Google verification with privacy policy and terms of service
- **Quotas**: Free tier allows 10,000 requests/day for the Photos Library API

## Google Photos APIs Options

### 1. Picker API (Recommended for Import)
- **Use case**: Let users select photos from their Google Photos library
- **Pros**: Simple, no server-side upload, user controls what to share
- **Cons**: Requires user interaction each time

### 2. Library API
- **Use case**: Sync/backup photos programmatically
- **Pros**: Full control, can sync automatically
- **Cons**: More complex, requires OAuth verification

## Implementation Plan

### Phase 1: Basic Integration (Picker API)

#### 1. Setup OAuth 2.0
```ruby
# Gemfile
gem 'google-api-client', '~> 0.11'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
```

#### 2. Create OAuth Controller
```ruby
# app/controllers/oauth/google_photos_controller.rb
class Oauth::GooglePhotosController < ApplicationController
  def callback
    # Handle OAuth callback
    # Store tokens in User model
  end
end
```

#### 3. Create Google Photos Service
```ruby
# app/services/google_photos_service.rb
class GooglePhotosService
  def initialize(user)
    @user = user
  end

  def create_picker_session
    # Create Picker API session
  end
end
```

#### 4. Add Routes
```ruby
# config/routes.rb
resource :oauth, only: [] do
  namespace :google_photos do
    get :callback
    post :token
  end
end
```

### Phase 2: Photo Import

#### 1. Picker Integration View
```erb
<!-- app/views/galleries/_google_photos_picker.html.erb -->
<%= button_to "Importar do Google Photos", 
    google_photos_auth_path, 
    method: :post,
    data: { turbo_frame: "import_modal" } %>
```

#### 2. Import Controller
```ruby
# app/controllers/imports_controller.rb
class ImportsController < ApplicationController
  def google_photos
    service = GooglePhotosService.new(current_user)
    @session_url = service.create_picker_session
  end
end
```

### Phase 3: Enhanced Sync (Library API)

#### Required Scopes
- `https://www.googleapis.com/auth/photoslibrary.readonly` - Read access
- `https://www.googleapis.com/auth/photoslibrary` - Read/write access

#### Features
1. **List Albums**: Show user's Google Photos albums
2. **Import Album**: Import entire album to Doce Lar
3. **Auto-sync**: Optional background sync

## Security Considerations

1. **OAuth Verification Required**
   - Google requires app verification before launch
   - "Unverified app" warning shown until verified

2. **Token Storage**
   - Encrypt OAuth tokens at rest
   - Implement refresh token rotation

3. **Data Privacy**
   - Clearly state what data is accessed
   - Allow users to revoke access anytime

## Files to Create

```
app/
├── controllers/
│   ├── oauth/
│   │   └── google_photos_controller.rb
│   └── imports_controller.rb
├── services/
│   └── google_photos_service.rb
├── models/
│   └── user.rb (add google_photos_token, etc.)
├── views/
│   ├── imports/
│   │   └── google_photos.html.erb
│   └── galleries/
│       └── _import_modal.html.erb
└── jobs/
    └── sync_google_photos_job.rb

config/
├── initializers/
│   └── google_api.rb
└── credentials.yml.enc (add GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
```

## Environment Variables Needed

```bash
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_REDIRECT_URI=http://localhost:3000/oauth/google_photos_callback
```

For production, update `GOOGLE_REDIRECT_URI` to your production domain.

## Testing

1. **Unit Tests**: GooglePhotosService methods
2. **Controller Tests**: OAuth callback flow
3. **Feature Tests**: Import workflow

## Future Enhancements

1. **Export to Google Photos**: Backup Doce Lar galleries to Google
2. **Share Links**: Generate shareable links to Google Photos albums
3. **Auto-tagging**: Use Google Vision API for auto-captioning
