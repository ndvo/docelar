# Google Photos Integration Plan

## Overview

Integrate Google Photos to allow users to import photos from their Google Photos library into Doce Lar galleries.

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

```
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
```

## Testing

1. **Unit Tests**: GooglePhotosService methods
2. **Controller Tests**: OAuth callback flow
3. **Feature Tests**: Import workflow

## Future Enhancements

1. **Export to Google Photos**: Backup Doce Lar galleries to Google
2. **Share Links**: Generate shareable links to Google Photos albums
3. **Auto-tagging**: Use Google Vision API for auto-captioning
